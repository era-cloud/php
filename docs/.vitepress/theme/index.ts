import { h } from 'vue'
import DefaultTheme from 'vitepress/theme'
import TagTable from './TagTable.vue'

export default {
  extends: DefaultTheme,
  Layout: DefaultTheme.Layout,
  enhanceApp({ app }) {
    app.component('TagTable', TagTable)
  },
}
