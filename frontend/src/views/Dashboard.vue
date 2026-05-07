<template>
  <div class="dashboard">
    <h1 class="page-title">生产看板</h1>
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-value">{{ stats.openWo }}</div>
        <div class="stat-label">待排工单</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">{{ stats.inProgressWo }}</div>
        <div class="stat-label">生产中</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">{{ stats.completedWo }}</div>
        <div class="stat-label">今日完成</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">{{ stats.exceptions }}</div>
        <div class="stat-label">异常待处理</div>
      </div>
    </div>

    <div class="dashboard-grid">
      <div class="panel">
        <h2>最新工单</h2>
        <table class="data-table">
          <thead><tr><th>工单号</th><th>物料</th><th>数量</th><th>状态</th><th>交期</th></tr></thead>
          <tbody>
            <tr v-for="wo in recentWos" :key="wo.id">
              <td>{{ wo.woNumber }}</td>
              <td>{{ wo.itemName }}</td>
              <td>{{ wo.planQty }}</td>
              <td><span :class="'badge badge-' + wo.status">{{ wo.statusText }}</span></td>
              <td>{{ wo.requiredDate?.slice(0,10) }}</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="panel">
        <h2>排程日历（本月）</h2>
        <div class="schedule-summary">
          <div v-for="s in schedules" :key="s.id" class="schedule-item">
            <span class="schedule-date">{{ s.scheduleDate?.slice(0,10) }}</span>
            <span :class="'badge badge-' + s.status">{{ s.status }}</span>
            <span class="schedule-algo">{{ s.algorithmType }}</span>
            <span class="schedule-ops">{{ s.scheduledOpCount }} 工序</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'

const stats = ref({ openWo: 0, inProgressWo: 0, completedWo: 0, exceptions: 0 })
const recentWos = ref<any[]>([])
const schedules = ref<any[]>([])

onMounted(async () => {
  try {
    const [woRes, schRes, excRes] = await Promise.all([
      axios.get('/api/v1/work-orders?status=RELEASED'),
      axios.get('/api/v1/schedules?factoryId=1'),
      axios.get('/api/v1/exceptions?status=OPEN'),
    ])
    recentWos.value = woRes.data.data ?? woRes.data
    schedules.value = schRes.data.data ?? schRes.data
    stats.value.openWo = recentWos.value.length
    stats.value.exceptions = (excRes.data.data ?? excRes.data).length
  } catch (e) {
    console.error('看板加载失败', e)
  }
})
</script>

<style scoped>
.stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 24px; }
.stat-card { background: #fff; border-radius: 8px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,.1); text-align: center; }
.stat-value { font-size: 32px; font-weight: 700; color: #1976d2; }
.stat-label { font-size: 13px; color: #666; margin-top: 4px; }
.dashboard-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.panel { background: #fff; border-radius: 8px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,.1); }
.panel h2 { font-size: 16px; margin-bottom: 16px; color: #333; }
.data-table { width: 100%; border-collapse: collapse; font-size: 14px; }
.data-table th { text-align: left; padding: 8px 12px; border-bottom: 2px solid #eee; color: #666; font-weight: 600; }
.data-table td { padding: 10px 12px; border-bottom: 1px solid #f0f0f0; }
.schedule-item { display: flex; align-items: center; gap: 12px; padding: 8px 0; border-bottom: 1px solid #f5f5f5; font-size: 14px; }
.schedule-date { font-weight: 600; min-width: 90px; }
.schedule-algo { color: #666; }
.schedule-ops { color: #999; font-size: 13px; }
.badge { padding: 2px 8px; border-radius: 12px; font-size: 12px; font-weight: 600; }
.badge-DRAFT { background: #f5f5f5; color: #666; }
.badge-RELEASED { background: #e3f2fd; color: #1976d2; }
.badge-IN_PROGRESS { background: #fff3e0; color: #e65100; }
.badge-COMPLETED { background: #e8f5e9; color: #2e7d32; }
.badge-PUBLISHED { background: #e8f5e9; color: #2e7d32; }
.badge-OPEN { background: #ffebee; color: #c62828; }
.badge-WARNING { background: #fff8e1; color: #f57f17; }
.badge-ERROR { background: #ffebee; color: #c62828; }
.page-title { font-size: 20px; margin-bottom: 20px; color: #333; }
</style>