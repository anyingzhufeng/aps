import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/', name: 'Home', component: () => import('./views/Dashboard.vue') },
  { path: '/work-orders', name: 'WorkOrders', component: () => import('./views/WorkOrders.vue') },
  { path: '/work-orders/new', name: 'CreateWO', component: () => import('./views/WorkOrderForm.vue') },
  { path: '/schedule', name: 'Schedule', component: () => import('./views/Schedule.vue') },
  { path: '/inventory', name: 'Inventory', component: () => import('./views/Inventory.vue') },
  { path: '/exceptions', name: 'Exceptions', component: () => import('./views/Exceptions.vue') },
]

export default createRouter({
  history: createWebHistory(),
  routes,
})