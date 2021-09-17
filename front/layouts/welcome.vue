<template>
  <v-app>
    <wel-app-bar />
    <v-img
      dark
      :src="topimage"
      gradient="to top right, rgba(100,100,0,.2), rgba(0,0,0,.1)"
      :height="imgHeight"
    >
      <v-row
        align="center"
        justify="center"
        :style="{ height: `${imgHeight}px` }"
      >
        <v-col
          cols="12"
          class="text-center"
        >
          <h1 class="display-5 mb-4">
            Foodcom
          </h1>
          <h4
            class="subheading"
            :style="{ letterSpacing: '5px' }"
          >
          </h4>
        </v-col>
      </v-row>
    </v-img>
    <bef-login-footer />
  </v-app>
</template>

<script>
import { mapGetters } from 'vuex'
import welAppBar from '../components/welcome/welAppBar.vue'
import befLoginFooter from '~/components/beforeLogin/befLoginFooter.vue'
import topImage from '~/assets/images/toppage.png'
export default {
  components: {
    welAppBar,
    befLoginFooter
  },
  data () {
    return {
      imgHeight: 500,
      topimage: topImage
    }
  },
  computed: {
    ...mapGetters({
      loggedIn: 'auth/isAuthenticated'
    }),
    status () {
      return {
        status: this.loggedIn
      }
    }
  },
  methods: {
    console () {
      // console.log(this.$store.getters.isAuthenticated)
    }
  }
}
</script>
