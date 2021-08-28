export const state = () => ({
  user: {}
})

export const getters = {
  user (state) {
    return state.user
  }
}

export const mutations = {
  setUser (state, payload) {
    state.user = payload
  }
}

export const actions = {
  setUser ({ commit }, user) {
    commit('setUser', user)
  }
}
