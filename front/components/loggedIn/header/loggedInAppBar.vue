<template>
  <v-app-bar
    app
    elevation="1"
    clipped-left
    color="white"
  >
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
    <!-- アカウントナビドロワー -->
    <v-menu
      app
      offset-x
      offset-y
      max-width="250"
    >
      <template v-slot:activator="{ on }">
        <v-btn
          icon
          v-on="on"
        >
          <v-icon>
            mdi-account-circle
          </v-icon>
        </v-btn>
      </template>
      <v-list
        dense
      >
        <v-subheader>
          ログイン中のユーザー
        </v-subheader>
        <v-list-item>
          <v-list-item-content>
            <v-list-item-subtitle>
              {{ currentUser.name }}
            </v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>

        <v-divider />

        <v-subheader>
          アカウント
        </v-subheader>

        <template v-for="(menu, i) in accountMenus">
          <v-divider
            v-if="menu.divider"
            :key="`menu-divider-${i}`"
          />

          <v-list-item
            :key="`menu-list-${i}`"
            :to="{ name: menu.name }"
          >
            <v-list-item-icon class="mr-2">
              <v-icon size="22" v-text="menu.icon" />
            </v-list-item-icon>
            <v-list-item-title>
              {{ $my.pageTitle(menu.name) }}
            </v-list-item-title>
          </v-list-item>
        </template>
      </v-list>
    </v-menu>
    <!-- ここまで -->
  </v-app-bar>
</template>

<script>
import { mapGetters } from 'vuex'
import appLogo from '../../ui/appLogo.vue'
import appTitle from '../../ui/appTitle.vue'
export default {
  components: {
    appLogo,
    appTitle
  },
  data () {
    return {
      accountMenus: [
        { name: 'account-settings', icon: 'mdi-account-cog' },
        { name: 'logout', icon: 'mdi-logout-variant', divider: true }
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
  }
}
</script>
