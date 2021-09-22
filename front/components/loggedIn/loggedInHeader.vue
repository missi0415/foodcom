<template>
  <div>
    <logged-in-nav-drawer
    />
    <mobile-nav-bar />
    <!-- eslint-disable-next-line -->
    <logged-in-app-bar #nav-icon>
      <v-app-bar-nav-icon
        @click="drawer = !drawer"
      />
    </logged-in-app-bar>
  </div>
</template>

<script>
import LoggedInAppBar from './header/loggedInAppBar.vue'
import loggedInNavDrawer from './header/loggedInNavDrawer.vue'
import MobileNavBar from './header/mobileNavBar.vue'
export default {
  components: {
    loggedInNavDrawer,
    LoggedInAppBar,
    MobileNavBar
  },
  data () {
    return {
      drawer: null
    }
  }
}
</script>
