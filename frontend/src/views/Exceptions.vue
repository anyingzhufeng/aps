<template>
  <div class="exceptions">
    <h1 class="page-title">异常管理</h1>
    <div class="filter-bar">
      <select v-model="filterStatus" class="filter-select" @change="loadExceptions">
        <option value="">全部状态</option>
        <option value="OPEN">待处理</option>
        <option value="ACKNOWLEDGED">已确认</option>
        <option value="RESOLVED">已解决</option>
      </select>
      <select v-model="filterLevel" class="filter-select" @change="loadExceptions">
        <option value="">全部级别</option>
        <option value="INFO">通知</option>
        <option value="WARNING">警告</option>
        <option value="ERROR">错误</option>
      </select>
    </div>
    <div class="panel">
      <table class="data-table">
        <thead>
          <tr><th>异常号</th><th>工单</th><th>类型</th><th>描述</th><th>级别</th><th>状态</th><th>时间</th><th>操作</th></tr>
        </thead>
        <tbody>
          <tr v-for="e in exceptions" :key="e.id" :class="'row-' + e.level">
            <td class="code">{{ e.exceptionCode }}</td>
            <td>{{ e.woNumber }}</td>
            <td>{{ e.exceptionType }}</td>
            <td class="desc">{{ e.description }}</td>
            <td><span :class="'level level-' + e.level">{{ e.level }}</span></td>
            <td><span :class="'badge badge-' + e.status">{{ e.statusText }}</span></td>
            <td>{{ e.occurredAt?.slice(0,16) }}</td>
            <td>
              <button v-if="e.status === 'OPEN'" class="btn btn-sm" @click="acknowledge(e)">确认</button>
              <button v-if="e.status !== 'RESOLVED'" class="btn btn-sm btn-resolve" @click="resolve(e)">解决</button>
            </td>
          </tr>
          <tr v-if="exceptions.length === 0">
            <td colspan="8" class="empty-row">暂无异常</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'

const exceptions = ref<any[]>([])
const filterStatus = ref('')
const filterLevel = ref('')

const statusText: Record<string, string> = {
  OPEN: '待处理', ACKNOWLEDGED: '已确认', RESOLVED: '已解决',
}

const loadExceptions = async () => {
  const params: any = {}
  if (filterStatus.value) params.status = filterStatus.value
  if (filterLevel.value) params.level = filterLevel.value
  const res = await axios.get('/api/v1/exceptions', { params })
  exceptions.value = (res.data.data ?? res.data).map((e: any) => ({
    ...e, statusText: statusText[e.status] ?? e.status,
  }))
}

const acknowledge = async (e: any) => {
  await axios.put(`/api/v1/exceptions/${e.id}/acknowledge`)
  loadExceptions()
}
const resolve = async (e: any) => {
  const resolution = prompt('输入解决方案：')
  if (!resolution) return
  await axios.put(`/api/v1/exceptions/${e.id}/resolve`, { resolution })
  loadExceptions()
}

onMounted(loadExceptions)
</script>

<style scoped>
.page-title { font-size: 20px; margin-bottom: 20px; color: #333; }
.filter-bar { display: flex; gap: 10px; margin-bottom: 16px; }
.filter-select { padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; }
.panel { background: #fff; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,.1); }
.data-table { width: 100%; border-collapse: collapse; font-size: 14px; }
.data-table th { text-align: left; padding: 10px 12px; border-bottom: 2px solid #eee; color: #666; font-weight: 600; background: #fafafa; }
.data-table td { padding: 10px 12px; border-bottom: 1px solid #f5f5f5; }
.desc { max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; color: #666; font-size: 13px; }
.code { font-weight: 600; color: #1976d2; }
.level { padding: 2px 8px; border-radius: 12px; font-size: 12px; font-weight: 700; }
.level-INFO { background: #e3f2fd; color: #1976d2; }
.level-WARNING { background: #fff8e1; color: #f57f17; }
.level-ERROR { background: #ffebee; color: #c62828; }
.badge { padding: 2px 8px; border-radius: 12px; font-size: 12px; font-weight: 600; }
.badge-OPEN { background: #ffebee; color: #c62828; }
.badge-ACKNOWLEDGED { background: #fff8e1; color: #f57f17; }
.badge-RESOLVED { background: #e8f5e9; color: #2e7d32; }
.empty-row { text-align: center; color: #999; padding: 32px; }
.btn { padding: 6px 12px; border: none; border-radius: 6px; cursor: pointer; font-size: 13px; font-weight: 600; }
.btn-sm { background: #e3f2fd; color: #1976d2; }
.btn-resolve { background: #e8f5e9; color: #2e7d32; }
</style>