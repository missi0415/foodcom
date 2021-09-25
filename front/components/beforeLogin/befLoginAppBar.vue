<template>
  <v-app-bar
    app
    :height="appBarHeight"
    color="white"
  >
    <nuxt-link
      to="/"
      class="text-decoration-none"
    >
      <app-logo
      />
    </nuxt-link>

    <app-title
      class="hidden-mobile-and-down"
    />

    <v-spacer />
    <gest-login-link />
    <signup-link />
    <login-link />
  </v-app-bar>
</template>

<script>
import appLogo from '../ui/appLogo.vue'
import appTitle from '../ui/appTitle.vue'
import signupLink from './signupLink.vue'
import loginLink from './loginLink.vue'
import GestLoginLink from './gestLoginLink.vue'

export default {
  components: { appLogo, signupLink, loginLink, appTitle, GestLoginLink },
  data ({ $store }) {
    return {
      appBarHeight: $store.state.styles.beforeLogin.appBarHeight
    }
  }
}
</script>
