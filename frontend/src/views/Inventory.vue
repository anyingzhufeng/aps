<template>
  <div class="inventory-view">
    <h1 class="page-title">库存管理</h1>
    <div class="filter-bar">
      <input v-model="searchItem" placeholder="搜索物料编码/名称" class="filter-input" @input="loadStock" />
      <select v-model="filterWarehouse" class="filter-select" @change="loadStock">
        <option value="">全部仓库</option>
        <option v-for="wh in warehouses" :key="wh.id" :value="wh.id">{{ wh.locationName }}</option>
      </select>
    </div>
    <div class="panel">
      <table class="data-table">
        <thead>
          <tr><th>物料编码</th><th>物料名称</th><th>仓库</th><th>批次</th><th>库存量</th><th>可用量</th><th>单位</th><th>操作</th></tr>
        </thead>
        <tbody>
          <tr v-for="s in stocks" :key="s.id">
            <td>{{ s.itemCode }}</td>
            <td>{{ s.itemName }}</td>
            <td>{{ s.warehouseName }}</td>
            <td>{{ s.lotNo }}</td>
            <td class="num">{{ s.stockQty }}</td>
            <td class="num" :class="{ low: s.availableQty < 10 }">{{ s.availableQty }}</td>
            <td>{{ s.unitCode }}</td>
            <td><button class="btn btn-sm" @click="adjustStock(s)">调整</button></td>
          </tr>
          <tr v-if="stocks.length === 0"><td colspan="8" class="empty-row">暂无库存数据</td></tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'

const stocks = ref<any[]>([])
const warehouses = ref<any[]>([])
const searchItem = ref('')
const filterWarehouse = ref('')

const loadStock = async () => {
  const params: any = { pageSize: 100 }
  if (searchItem.value) params.search = searchItem.value
  if (filterWarehouse.value) params.warehouseId = filterWarehouse.value
  const res = await axios.get('/api/v1/inventory/stocks', { params })
  stocks.value = res.data.data ?? res.data
}

const adjustStock = async (s: any) => {
  const qty = parseFloat(prompt(`调整 ${s.itemName} 可用量（原：${s.availableQty}）：`) ?? s.availableQty)
  if (isNaN(qty)) return
  await axios.put(`/api/v1/inventory/stocks/${s.id}`, { availableQty: qty })
  loadStock()
}

onMounted(async () => {
  loadStock()
  const whRes = await axios.get('/api/v1/warehouses')
  warehouses.value = whRes.data.data ?? whRes.data
})
</script>

<style scoped>
.page-title { font-size: 20px; margin-bottom: 20px; color: #333; }
.filter-bar { display: flex; gap: 10px; margin-bottom: 16px; }
.filter-input, .filter-select { padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; }
.filter-input { flex: 1; }
.panel { background: #fff; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,.1); }
.data-table { width: 100%; border-collapse: collapse; font-size: 14px; }
.data-table th { text-align: left; padding: 10px 12px; border-bottom: 2px solid #eee; color: #666; font-weight: 600; background: #fafafa; }
.data-table td { padding: 10px 12px; border-bottom: 1px solid #f5f5f5; }
.num { text-align: right; font-variant-numeric: tabular-nums; }
.low { color: #c62828; font-weight: 700; }
.empty-row { text-align: center; color: #999; padding: 32px; }
.btn { padding: 6px 12px; border: none; border-radius: 6px; cursor: pointer; font-size: 13px; font-weight: 600; }
.btn-sm { background: #e3f2fd; color: #1976d2; }
</style>