import firebase from '~/plugins/firebase.js'

export const state = () => ({
  user: null,
  data: null,
  currentUserId: null
})

export const getters = {
  user (state) {
    return state.user
  },
  isAuthenticated (state) {
    // Userがログインできたらtrueを返す
    return !!state.user && !!state.data
  },
  data (state) {
    return state.data
  },
  currentUserId (state) {
    return state.currentUserId
  }
}

export const mutations = {
  setData (state, payload) {
    state.data = payload
  },
  setUser (state, payload) {
    state.user = payload
  },
  setCurrentUserId (state, payload) {
    state.currentUserId = payload
  }
}

export const actions = {
  async login ({ dispatch }, user) {
    const userInfo = { email: user.email, uid: user.uid }
    await dispatch('setUser', userInfo)
    await dispatch('loadData', userInfo.uid)
    await dispatch('loadCurrentUserId', userInfo.uid)
  },

  async logout ({ commit }) {
    await firebase.auth().signOut()
      .then(() => {
        this.$router.replace('/')
        commit('setUser', null)
        commit('setData', null)
        commit('setCurrentUserId', null)
      })
      .catch((err) => {
        // eslint-disable-next-line no-console
        console.error(err)
      })
  },

  setUser ({ commit }, user) {
    commit('setUser', user)
  },

  async loadData ({ commit }, payload) {
    try {
      const data = await this.$axios.$get(`/api/v1/find_login_user/${payload}`)
      commit('setData', data)
    } catch (err) {
      // eslint-disable-next-line no-console
      console.log(err)
    }
  },
  async loadCurrentUserId ({ commit }, payload) {
    try {
      const data = await this.$axios.$get(`/api/v1/find_login_user/${payload}`)
      commit('setCurrentUserId', data.id)
    } catch (err) {
      // eslint-disable-next-line no-console
      console.log(err)
    }
  }
}
