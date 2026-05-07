<template>
  <div class="schedule-view">
    <div class="page-header">
      <h1 class="page-title">排程管理</h1>
      <div class="header-actions">
        <select v-model="selectedAlgo" class="algo-select">
          <option value="GA">遗传算法 GA</option>
          <option value="CP_SAT">约束规划 CP-SAT</option>
          <option value="MILP">混合整数 MILP</option>
          <option value="HEURISTIC">启发式</option>
        </select>
        <button class="btn btn-primary" @click="runSchedule" :disabled="running">
          {{ running ? '排程中...' : '⚡ 立即排程' }}
        </button>
      </div>
    </div>

    <!-- 排程结果甘特图 -->
    <div class="panel gantt-panel">
      <h2>排程甘特图</h2>
      <div v-if="ganttData.length === 0" class="empty-state">
        暂无排程数据，点击「立即排程」生成
      </div>
      <div v-else class="gantt-chart">
        <div class="gantt-header">
          <div class="gantt-y-axis">工序</div>
          <div class="gantt-timeline">
            <div v-for="day in timelineDays" :key="day" class="gantt-day">{{ day }}</div>
          </div>
        </div>
        <div class="gantt-rows">
          <div v-for="(row, i) in ganttData" :key="i" class="gantt-row">
            <div class="gantt-label">{{ row.label }}</div>
            <div class="gantt-bars">
              <div class="gantt-timeline">
                <div v-for="day in timelineDays" :key="day" class="gantt-day-cell" />
                <div
                  class="gantt-bar"
                  :style="{
                    left: row.startPct + '%',
                    width: row.widthPct + '%',
                    background: row.color
                  }"
                  :title="row.label + '：' + row.startText + ' → ' + row.endText"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 历史排程记录 -->
    <div class="panel">
      <h2>历史排程记录</h2>
      <table class="data-table">
        <thead>
          <tr><th>排程号</th><th>日期</th><th>算法</th><th>工序</th><th>状态</th><th>耗时</th><th>操作</th></tr>
        </thead>
        <tbody>
          <tr v-for="s in schedules" :key="s.id">
            <td class="code">{{ s.scheduleCode }}</td>
            <td>{{ s.scheduleDate?.slice(0,10) }}</td>
            <td><span class="algo-tag">{{ s.algorithmType }}</span></td>
            <td>{{ s.scheduledOpCount }} / {{ s.totalOpCount }}</td>
            <td><span :class="'badge badge-' + s.status">{{ s.status }}</span></td>
            <td>{{ s.solveTimeSeconds?.toFixed(2) }}秒</td>
            <td>
              <button v-if="s.status === 'DRAFT'" class="btn btn-sm" @click="publishSchedule(s)">发布</button>
              <button class="btn btn-sm btn-danger" @click="deleteSchedule(s)">删除</button>
            </td>
          </tr>
          <tr v-if="schedules.length === 0">
            <td colspan="7" class="empty-row">暂无排程记录</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'

const running = ref(false)
const selectedAlgo = ref('GA')
const schedules = ref<any[]>([])
const ganttData = ref<any[]>([])

const timelineDays = computed(() => {
  const days: string[] = []
  const start = new Date()
  for (let i = 0; i < 14; i++) {
    const d = new Date(start); d.setDate(d.getDate() + i)
    days.push(`${d.getMonth()+1}/${d.getDate()}`)
  }
  return days
})

const runSchedule = async () => {
  running.value = true
  try {
    const res = await axios.post('/api/v1/schedules/run', {
      factoryId: 1,
      algorithmType: selectedAlgo.value,
    })
    const result = res.data.data ?? res.data
    buildGantt(result)
    loadSchedules()
  } catch (e: any) {
    alert('排程失败：' + (e.message ?? '未知错误'))
  } finally {
    running.value = false
  }
}

const buildGantt = (result: any) => {
  const ops = result.operations ?? []
  ganttData.value = ops.map((op: any, i: number) => {
    const colors = ['#1976d2','#388e3c','#f57c00','#7b1fa2','#c62828','#00838f']
    const start = new Date(op.scheduledStartTime ?? new Date())
    const end = new Date(op.scheduledEndTime ?? new Date())
    const totalMs = 14 * 24 * 3600 * 1000
    const startMs = start.getTime() - Date.now()
    const widthMs = end.getTime() - start.getTime()
    return {
      label: `工序 ${op.woOperationId} / ${op.workCenterId}`,
      startPct: (startMs / totalMs) * 100,
      widthPct: Math.max((widthMs / totalMs) * 100, 1),
      startText: start.toLocaleDateString(),
      endText: end.toLocaleDateString(),
      color: colors[i % colors.length],
    }
  })
}

const loadSchedules = async () => {
  const res = await axios.get('/api/v1/schedules?factoryId=1&pageSize=20')
  schedules.value = res.data.data ?? res.data
}

const publishSchedule = async (s: any) => {
  await axios.put(`/api/v1/schedules/${s.id}/publish`)
  loadSchedules()
}
const deleteSchedule = async (s: any) => {
  if (!confirm(`删除 ${s.scheduleCode}？`)) return
  await axios.delete(`/api/v1/schedules/${s.id}`)
  loadSchedules()
}

onMounted(loadSchedules)
</script>

<style scoped>
.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.page-title { font-size: 20px; color: #333; }
.header-actions { display: flex; gap: 12px; align-items: center; }
.algo-select { padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; }
.panel { background: #fff; border-radius: 8px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,.1); margin-bottom: 16px; }
.panel h2 { font-size: 16px; margin-bottom: 16px; color: #333; }
.empty-state { text-align: center; color: #999; padding: 40px; font-size: 14px; }
.gantt-panel { overflow: auto; }
.gantt-chart { font-size: 13px; }
.gantt-header, .gantt-row { display: flex; align-items: center; }
.gantt-y-axis { width: 140px; flex-shrink: 0; font-weight: 600; color: #666; }
.gantt-timeline { display: flex; flex: 1; }
.gantt-day { width: 60px; text-align: center; color: #999; border-left: 1px solid #f0f0f0; padding: 4px 0; }
.gantt-day-cell { width: 60px; height: 32px; border-left: 1px solid #f5f5f5; }
.gantt-label { width: 140px; flex-shrink: 0; padding: 4px 8px; font-size: 12px; color: #555; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.gantt-bar { position: absolute; height: 24px; border-radius: 4px; top: 4px; min-width: 4px; }
.gantt-bars { position: relative; flex: 1; }
.data-table { width: 100%; border-collapse: collapse; font-size: 14px; }
.data-table th { text-align: left; padding: 10px 12px; border-bottom: 2px solid #eee; color: #666; font-weight: 600; }
.data-table td { padding: 10px 12px; border-bottom: 1px solid #f0f0f0; }
.code { font-weight: 600; color: #1976d2; }
.algo-tag { background: #e3f2fd; color: #1976d2; padding: 2px 8px; border-radius: 12px; font-size: 12px; font-weight: 600; }
.empty-row { text-align: center; color: #999; padding: 24px; }
.btn { padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; font-weight: 600; }
.btn-primary { background: #1976d2; color: #fff; }
.btn-primary:disabled { background: #90caf9; cursor: not-allowed; }
.btn-sm { padding: 4px 10px; font-size: 12px; background: #e3f2fd; color: #1976d2; }
.btn-danger { background: #ffebee; color: #c62828; }
.badge { padding: 2px 8px; border-radius: 12px; font-size: 12px; font-weight: 600; }
.badge-DRAFT { background: #f5f5f5; color: #666; }
.badge-PUBLISHED { background: #e8f5e9; color: #2e7d32; }
</style>