<template>
  <div id="app">
    <nav class="navbar">
      <div class="nav-brand">APS 高级计划排程</div>
      <div class="nav-links">
        <router-link to="/">首页</router-link>
        <router-link to="/work-orders">工单</router-link>
        <router-link to="/schedule">排程</router-link>
        <router-link to="/inventory">库存</router-link>
        <router-link to="/exceptions">异常</router-link>
      </div>
    </nav>
    <main class="main-content">
      <router-view />
    </main>
  </div>
</template>

<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: 'Segoe UI', sans-serif; background: #f5f5f5; color: #333; }
.navbar {
  background: #1976d2; color: #fff; padding: 0 24px; display: flex;
  align-items: center; height: 56px; gap: 32px; box-shadow: 0 2px 4px rgba(0,0,0,.15);
}
.nav-brand { font-size: 18px; font-weight: 700; }
.nav-links { display: flex; gap: 20px; }
.nav-links a { color: rgba(255,255,255,.85); text-decoration: none; font-size: 14px; }
.nav-links a:hover, .nav-links a.router-link-active { color: #fff; font-weight: 600; }
.main-content { padding: 24px; max-width: 1400px; margin: 0 auto; width: 100%; }
</style>