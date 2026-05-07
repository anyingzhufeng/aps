<template>
  <div class="work-orders">
    <div class="page-header">
      <h1 class="page-title">工单管理</h1>
      <button class="btn btn-primary" @click="$router.push('/work-orders/new')">+ 新建工单</button>
    </div>

    <!-- 搜索过滤 -->
    <div class="filter-bar">
      <select v-model="filterStatus" class="filter-select" @change="loadWorkOrders">
        <option value="">全部状态</option>
        <option value="DRAFT">草稿</option>
        <option value="RELEASED">已发布</option>
        <option value="IN_PROGRESS">生产中</option>
        <option value="COMPLETED">已完成</option>
        <option value="CLOSED">已关闭</option>
        <option value="CANCELLED">已取消</option>
      </select>
      <input v-model="searchText" placeholder="搜索工单号 / 物料名称" class="filter-input" @input="loadWorkOrders" />
      <button class="btn btn-secondary" @click="runSchedule">⚡ 触发排程</button>
    </div>

    <!-- 表格 -->
    <div class="panel">
      <table class="data-table">
        <thead>
          <tr>
            <th>工单号</th>
            <th>物料</th>
            <th>数量</th>
            <th>状态</th>
            <th>优先级</th>
            <th>交期</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="wo in workOrders" :key="wo.id">
            <td class="wo-number">{{ wo.woNumber }}</td>
            <td>{{ wo.itemName ?? wo.itemId }}</td>
            <td>{{ wo.planQty }}</td>
            <td><span :class="'badge badge-' + wo.status">{{ wo.statusText }}</span></td>
            <td>
              <span v-if="wo.priority === 1" class="priority p1">紧急</span>
              <span v-else-if="wo.priority === 2" class="priority p2">高</span>
              <span v-else class="priority p3">普通</span>
            </td>
            <td>{{ wo.requiredDate?.slice(0,10) }}</td>
            <td class="actions">
              <button v-if="wo.status === 'DRAFT'" class="btn btn-sm" @click="releaseWo(wo)">发布</button>
              <button v-if="wo.status === 'RELEASED'" class="btn btn-sm" @click="startWo(wo)">开工</button>
              <button v-if="wo.status === 'IN_PROGRESS'" class="btn btn-sm" @click="completeWo(wo)">完工</button>
              <button class="btn btn-sm btn-danger" @click="cancelWo(wo)">取消</button>
            </td>
          </tr>
          <tr v-if="workOrders.length === 0">
            <td colspan="7" class="empty-row">暂无工单</td>
          </tr>
        </tbody>
      </table>
      <div class="pagination">
        <button class="btn btn-sm" :disabled="page <= 1" @click="page--; loadWorkOrders()">上一页</button>
        <span class="page-info">第 {{ page }} 页</span>
        <button class="btn btn-sm" @click="page++; loadWorkOrders()">下一页</button>
      </div>
    </div>

    <!-- 排程结果弹窗 -->
    <div v-if="scheduleResult" class="modal" @click.self="scheduleResult = null">
      <div class="modal-content">
        <h3>排程结果</h3>
        <pre>{{ JSON.stringify(scheduleResult, null, 2) }}</pre>
        <button class="btn btn-primary" @click="scheduleResult = null">关闭</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'

const router = useRouter()
const workOrders = ref<any[]>([])
const filterStatus = ref('')
const searchText = ref('')
const page = ref(1)
const scheduleResult = ref(null)

const statusText: Record<string, string> = {
  DRAFT: '草稿', RELEASED: '已发布', IN_PROGRESS: '生产中',
  COMPLETED: '已完成', CLOSED: '已关闭', CANCELLED: '已取消',
}

const loadWorkOrders = async () => {
  try {
    const params: any = { page: page.value, pageSize: 20 }
    if (filterStatus.value) params.status = filterStatus.value
    if (searchText.value) params.search = searchText.value
    const res = await axios.get('/api/v1/work-orders', { params })
    const data = res.data.data ?? res.data
    workOrders.value = (Array.isArray(data) ? data : []).map((wo: any) => ({
      ...wo,
      statusText: statusText[wo.status] ?? wo.status,
    }))
  } catch (e) {
    console.error('加载工单失败', e)
  }
}

const releaseWo = async (wo: any) => {
  await axios.put(`/api/v1/work-orders/${wo.id}/release`)
  loadWorkOrders()
}
const startWo = async (wo: any) => {
  await axios.put(`/api/v1/work-orders/${wo.id}/start`)
  loadWorkOrders()
}
const completeWo = async (wo: any) => {
  await axios.put(`/api/v1/work-orders/${wo.id}/complete`)
  loadWorkOrders()
}
const cancelWo = async (wo: any) => {
  if (!confirm(`取消工单 ${wo.woNumber}？`)) return
  await axios.put(`/api/v1/work-orders/${wo.id}/cancel`)
  loadWorkOrders()
}
const runSchedule = async () => {
  try {
    const res = await axios.post('/api/v1/schedules/run', {
      factoryId: 1,
      algorithmType: 'GA',
    })
    scheduleResult.value = res.data
    loadWorkOrders()
  } catch (e: any) {
    alert('排程失败：' + (e.message ?? '未知错误'))
  }
}

onMounted(loadWorkOrders)
</script>

<style scoped>
.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.page-title { font-size: 20px; color: #333; }
.filter-bar { display: flex; gap: 10px; margin-bottom: 16px; align-items: center; }
.filter-select, .filter-input { padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; }
.filter-input { flex: 1; }
.panel { background: #fff; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,.1); overflow: hidden; }
.data-table { width: 100%; border-collapse: collapse; font-size: 14px; }
.data-table th { text-align: left; padding: 12px 16px; border-bottom: 2px solid #eee; color: #666; font-weight: 600; background: #fafafa; }
.data-table td { padding: 12px 16px; border-bottom: 1px solid #f5f5f5; }
.wo-number { font-weight: 600; color: #1976d2; }
.actions { display: flex; gap: 6px; }
.priority { padding: 2px 8px; border-radius: 12px; font-size: 12px; font-weight: 600; }
.p1 { background: #ffebee; color: #c62828; }
.p2 { background: #fff3e0; color: #e65100; }
.p3 { background: #f5f5f5; color: #666; }
.empty-row { text-align: center; color: #999; padding: 32px; }
.pagination { display: flex; align-items: center; gap: 16px; padding: 16px; border-top: 1px solid #f0f0f0; }
.page-info { font-size: 14px; color: #666; }
.modal { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,.4); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal-content { background: #fff; border-radius: 12px; padding: 24px; width: 600px; max-height: 80vh; overflow: auto; }
.modal-content pre { background: #f5f5f5; padding: 16px; border-radius: 8px; font-size: 13px; margin: 16px 0; overflow: auto; }
.btn { padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; font-weight: 600; }
.btn-primary { background: #1976d2; color: #fff; }
.btn-secondary { background: #388e3c; color: #fff; }
.btn-danger { background: #d32f2f; color: #fff; }
.btn-sm { padding: 4px 10px; font-size: 12px; background: #e3f2fd; color: #1976d2; }
.badge { padding: 2px 8px; border-radius: 12px; font-size: 12px; font-weight: 600; }
.badge-DRAFT { background: #f5f5f5; color: #666; }
.badge-RELEASED { background: #e3f2fd; color: #1976d2; }
.badge-IN_PROGRESS { background: #fff3e0; color: #e65100; }
.badge-COMPLETED { background: #e8f5e9; color: #2e7d32; }
</style>