import type { ViteEnv } from '../vite.config'

export default (): ViteEnv => ({
  apiBase: process.env.VITE_API_BASE ?? '/api/v1',
})