export const state = () => ({
  loggedIn: false,
  // true ログイン後=> layouts/default.vue
  // false ログイン前=> layouts/welcome.vue
  styles: {
    beforeLogin: {
      appBarHeight: 56
    }
  }
})

export const getters = {}

export const mutations = {}

export const actions = {}
