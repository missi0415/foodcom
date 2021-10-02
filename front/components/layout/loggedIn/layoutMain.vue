<template>
  <v-container
  >
    <v-row
      class="d-flex justify-space-between"
    >
    <template v-if="$vuetify.breakpoint.xs">
      <v-col
        cols="12"
        class="mt-1"
      >
        <slot name="layout-main" />
      </v-col>
    </template>
    <template v-else>
      <v-col
        cols="10"
        class="mt-1"
      >
        <slot name="layout-main" />
      </v-col>
      <!-- <v-col
        cols="3"
        class="mt-2"
      >
        <v-card
          class="mb-5"
        >
          <adsbygoogle
            ad-slot="'8489344129'"
            ad-format=""
            :ad-style="gadStyle"
          />
        </v-card>
        <v-card>
          <adsbygoogle
            ad-slot="'8489344129'"
            ad-format=""
            :ad-style="gadStyle"
          />
        </v-card>
      </v-col> -->
    </template>
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
  },
  data: () => ({
    gadStyle: {
      display: 'inline-block',
      width: '300px',
      height: '250px'
    }
  })
}
</script>
