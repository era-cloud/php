import { defineConfig } from 'vitepress'

export default defineConfig({
  lang: 'zh-CN',
  title: 'era-cloud PHP 镜像',
  description: 'PHP + swoole/swow 的 Docker 镜像：分层构建、扩展版本 tag 矩阵、全量历史 tag 索引。',
  base: '/php/',
  // 设计文档不进站点（内部文档，留在仓库里即可）
  srcExclude: ['design-layering.md'],
  cleanUrls: true,
  lastUpdated: true,
  themeConfig: {
    nav: [
      { text: '基础镜像', link: '/base' },
      { text: '扩展镜像', link: '/extensions' },
      { text: '全部 tag', link: '/tags' },
    ],
    sidebar: [
      { text: '快速选择', link: '/' },
      { text: '基础镜像（cli / zts）', link: '/base' },
      { text: '扩展镜像（swoole / swow / thread）', link: '/extensions' },
      { text: '全部 tag 索引', link: '/tags' },
    ],
    outline: { label: '本页目录', level: [2, 3] },
    docFooter: { prev: '上一页', next: '下一页' },
    returnToTopLabel: '回到顶部',
    darkModeSwitchLabel: '主题',
    sidebarMenuLabel: '菜单',
    lastUpdated: { text: '最后更新' },
    search: { provider: 'local' },
  },
})
