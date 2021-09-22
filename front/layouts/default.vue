<template>
  <v-app>
    <template v-if="!isAuthenticated">
      <wel-app-bar />
    </template>
    <template v-else>
      <logged-in-header />
    </template>
    <v-main>
      <flash />
      <nuxt />
    </v-main>
    <!-- <bef-login-footer /> -->
  </v-app>
</template>

<script>
import { mapGetters } from 'vuex'
// import befLoginFooter from '../components/beforeLogin/befLoginFooter.vue'
import welAppBar from '../components/welcome/welAppBar.vue'
import flash from '../components/ui/flash.vue'
import loggedInHeader from '../components/loggedIn/loggedInHeader.vue'
export default {
  components: {
    // befLoginFooter,
    welAppBar,
    flash,
    loggedInHeader
  },
  computed: {
    ...mapGetters({
      isAuthenticated: 'auth/isAuthenticated',
      currentUser: 'auth/data',
      flash: 'flash/flash'
    })
  }
}
</script>
