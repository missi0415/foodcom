<template>
  <v-container
  >
    <v-row
      class="d-flex justify-space-between"
    >
      <v-col
        v-if="$vuetify.breakpoint.xs"
        cols="12"
        class="mt-1"
      >
        <slot name="layout-main" />
      </v-col>
      <v-col
        v-else
        cols="10"
        class="mt-1"
      >
        <slot name="layout-main" />
      </v-col>
      <!-- <v-col cols="3">
        <v-card>
          広告入れれたら
        </v-card>
      </v-col> -->
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
