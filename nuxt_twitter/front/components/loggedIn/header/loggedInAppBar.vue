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
      [ログイン状態:{{ isAuthenticated }}]
      [ユーザーid:{{ currentUser.id }}]
      [ユーザー名:{{ currentUser.name }}]
    <v-btn
      outlined
      @click="signOut"
    >
      ログアウト
    </v-btn>
  </v-app-bar>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'
import appLogo from '../../ui/appLogo.vue'
import appTitle from '../../ui/appTitle.vue'
export default {
  components: {
    appLogo,
    appTitle
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
    },
    ...mapGetters({
      isAuthenticated: 'auth/isAuthenticated',
      currentUser: 'auth/data',
      flash: 'flash/flash'
    })
  },
  methods: {
    ...mapActions({
      logout: 'auth/logout'
    }),
    signOut () {
      this.logout()
      this.$router.replace('/')
    }
  }
}
</script>
