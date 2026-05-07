import axios from 'axios'

const api = axios.create({
  baseURL: '/api/v1',
  timeout: 30000,
  headers: { 'Content-Type': 'application/json' },
})

// 响应拦截：统一处理错误
api.interceptors.response.use(
  res => res.data,
  err => {
    const msg = err.response?.data?.message ?? err.message
    console.error('API错误:', msg)
    return Promise.reject(err)
  }
)

// ===== 工单 =====
export const workOrderApi = {
  list: (params: any) => api.get('/work-orders', { params }),
  get: (id: number) => api.get(`/work-orders/${id}`),
  create: (data: any) => api.post('/work-orders', data),
  update: (id: number, data: any) => api.put(`/work-orders/${id}`, data),
  release: (id: number) => api.put(`/work-orders/${id}/release`),
  start: (id: number) => api.put(`/work-orders/${id}/start`),
  complete: (id: number, completedQty: number) => api.put(`/work-orders/${id}/complete`, { completedQty }),
  cancel: (id: number) => api.put(`/work-orders/${id}/cancel`),
}

// ===== 排程 =====
export const scheduleApi = {
  list: (params: any) => api.get('/schedules', { params }),
  run: (data: any) => api.post('/schedules/run', data),
  publish: (id: number) => api.put(`/schedules/${id}/publish`),
  delete: (id: number) => api.delete(`/schedules/${id}`),
}

// ===== 库存 =====
export const inventoryApi = {
  listStocks: (params: any) => api.get('/inventory/stocks', { params }),
  adjustStock: (id: number, data: any) => api.put(`/inventory/stocks/${id}`, data),
  listKittings: (params: any) => api.get('/inventory/kittings', { params }),
  getKitting: (id: number) => api.get(`/inventory/kittings/${id}`),
  executeKitting: (id: number) => api.post(`/inventory/kittings/${id}/execute`),
}

// ===== 异常 =====
export const exceptionApi = {
  list: (params: any) => api.get('/exceptions', { params }),
  acknowledge: (id: number) => api.put(`/exceptions/${id}/acknowledge`),
  resolve: (id: number, data: any) => api.put(`/exceptions/${id}/resolve`, data),
}

// ===== 主数据 =====
export const masterDataApi = {
  items: (params: any) => api.get('/items', { params }),
  factories: () => api.get('/factories'),
  workshops: (factoryId: number) => api.get(`/factories/${factoryId}/workshops`),
  workCenters: (workshopId: number) => api.get(`/workshops/${workshopId}/work-centers`),
  machines: (workCenterId: number) => api.get(`/work-centers/${workCenterId}/machines`),
}

export default api