<template>
  <v-container
    fluid
  >
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
export default {
  computed: {
    ...mapGetters({
      isAuthenticated: 'auth/isAuthenticated',
      currentUser: 'auth/data',
      flash: 'flash/flash'
    })
  }
}
</script>
