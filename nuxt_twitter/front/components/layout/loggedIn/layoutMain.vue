<template>
  <v-container
    fluid
  >
  layoutMain.vue
    <v-row>
      <v-col
        cols="9"
        class="mt-3"
      >
        <slot name="layout-main" />
      </v-col>
      <v-col cols="3">
        <v-card>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'
// import sidebar from '../../loggedIn/sidebar/sidebar.vue'
export default {
  // components: {
  //   sidebar
  // },
  computed: {
    ...mapGetters({
      isAuthenticated: 'auth/isAuthenticated',
      currentUser: 'auth/data',
      flash: 'flash/flash'
    })
  }
}
</script>
