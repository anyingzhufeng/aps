<template>
  <div class="work-order-form">
    <h1 class="page-title">{{ isEdit ? '编辑工单' : '新建工单' }}</h1>

    <form class="form-panel" @submit.prevent="submit">
      <div class="form-grid">
        <div class="form-group">
          <label>物料 *</label>
          <select v-model="form.itemId" required>
            <option value="">选择物料</option>
            <option v-for="item in items" :key="item.id" :value="item.id">
              {{ item.itemCode }} - {{ item.itemName }}
            </option>
          </select>
        </div>

        <div class="form-group">
          <label>工单类型 *</label>
          <select v-model="form.woType">
            <option value="NORMAL">普通工单</option>
            <option value="REPAIR">返修工单</option>
            <option value="SAMPLE">样品工单</option>
          </select>
        </div>

        <div class="form-group">
          <label>计划数量 *</label>
          <input v-model.number="form.planQty" type="number" min="1" placeholder="例：100" required />
        </div>

        <div class="form-group">
          <label>优先级</label>
          <select v-model.number="form.priority">
            <option :value="1">紧急</option>
            <option :value="2">高</option>
            <option :value="3">普通</option>
          </select>
        </div>

        <div class="form-group">
          <label>计划开始日期</label>
          <input v-model="form.plannedStartDate" type="date" />
        </div>

        <div class="form-group">
          <label>需求交期 *</label>
          <input v-model="form.requiredDate" type="date" required />
        </div>

        <div class="form-group full-width">
          <label>备注</label>
          <textarea v-model="form.remark" rows="3" placeholder="可选备注信息" />
        </div>
      </div>

      <div class="form-actions">
        <button type="submit" class="btn btn-primary" :disabled="saving">
          {{ saving ? '保存中...' : '保存工单' }}
        </button>
        <button type="button" class="btn btn-secondary" @click="$router.back()">取消</button>
      </div>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()
const isEdit = ref(false)
const saving = ref(false)
const items = ref<any[]>([])

const form = ref({
  itemId: '',
  planQty: null as number | null,
  woType: 'NORMAL',
  priority: 3,
  plannedStartDate: '',
  requiredDate: '',
  remark: '',
})

onMounted(async () => {
  if (route.query.id) {
    isEdit.value = true
    const res = await axios.get(`/api/v1/work-orders/${route.query.id}`)
    const wo = res.data.data ?? res.data
    form.value = { ...wo }
  }
  const itemRes = await axios.get('/api/v1/items?pageSize=100')
  items.value = itemRes.data.data ?? itemRes.data
})

const submit = async () => {
  saving.value = true
  try {
    if (isEdit.value) {
      await axios.put(`/api/v1/work-orders/${route.query.id}`, form.value)
    } else {
      await axios.post('/api/v1/work-orders', form.value)
    }
    router.push('/work-orders')
  } catch (e: any) {
    alert('保存失败：' + (e.message ?? '未知错误'))
  } finally {
    saving.value = false
  }
}
</script>

<style scoped>
.page-title { font-size: 20px; margin-bottom: 20px; color: #333; }
.form-panel { background: #fff; border-radius: 8px; padding: 24px; box-shadow: 0 1px 3px rgba(0,0,0,.1); }
.form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
.form-group { display: flex; flex-direction: column; gap: 6px; }
.form-group.full-width { grid-column: 1 / -1; }
.form-group label { font-size: 13px; font-weight: 600; color: #555; }
.form-group input, .form-group select, .form-group textarea {
  padding: 10px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px;
}
.form-group textarea { resize: vertical; }
.form-actions { display: flex; gap: 12px; margin-top: 24px; padding-top: 20px; border-top: 1px solid #eee; }
.btn { padding: 10px 20px; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; font-weight: 600; }
.btn-primary { background: #1976d2; color: #fff; }
.btn-secondary { background: #f5f5f5; color: #666; }
</style>