<template>
  <v-app>
    <logged-in-nav-drawer />
    <logged-in-app-bar />
    <v-main>
      <nuxt />
    </v-main>
  </v-app>
</template>

<script>
import loggedInAppBar from '../components/loggedIn/header/loggedInAppBar.vue'
import LoggedInNavDrawer from '../components/loggedIn/header/loggedInNavDrawer.vue'
export default {
  components: { loggedInAppBar, LoggedInNavDrawer }
}
</script>
