export const state = () => ({
  submitPost: false
})

export const getters = {
  submitPost (state) {
    return state.submitPost
  }
}

export const mutations = {
  setSubmitPost (state, payload) {
    state.submitPost = payload
  }
}

export const actions = {
  setSubmitPost ({ commit }, submitPost) {
    commit('setSubmitPost', submitPost)
  }
}
