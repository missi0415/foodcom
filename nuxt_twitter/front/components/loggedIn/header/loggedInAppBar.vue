<template>
  <v-app-bar
    app
    elevation="1"
    clipped-left
    color="white"
  >
  loggedInAppBar
    <nuxt-link
      to="/"
      class="text-decoration-none"
    >
      <app-logo />
    </nuxt-link>
    <app-title
    />
    <v-spacer />
    <new-post />
  </v-app-bar>
</template>

<script>
import appLogo from '../../ui/appLogo.vue'
import newPost from '../../post/newPost.vue'
import appTitle from '../../ui/appTitle.vue'
// import accountLink from './accountLink.vue'
export default {
  components: {
    appLogo,
    appTitle,
    newPost
    // accountLink,
  },
  data () {
    return {
      menus: [
        { title: 'users' },
        { title: 'posts' }
      ]
    }
  },
  computed: {
    notTopPage () {
      return this.$route.name !== 'index'
    }
  }
}
</script>
