<template>
  <v-navigation-drawer
    v-model="setDrawer"
    app
    clipped
    mobile-breakpoint="960"
  >
    <v-list>
      <v-list-item
        v-for="(nav, i) in navMenus"
        :key="`nav-${i}`"
        :to="$my.projectLinkTo($route.params.id, nav.name)"
      >
        <v-list-item-icon>
          <v-icon v-text="nav.icon" />
        </v-list-item-icon>

        <v-list-item-content>
          <v-list-item-title>
            {{ $my.pageTitle(nav.name) }}
          </v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-divider />
    </v-list>
  </v-navigation-drawer>
</template>

<script>
export default {
  props: {
    drawer: {
      type: Boolean,
      default: null
    }
  },
  data () {
    return {
      navMenus: [
        { name: 'project-id-home', icon: 'mdi-home' },
        { name: 'project-id-search', icon: 'mdi-magnify' },
        { name: 'project-id-notification', icon: 'mdi-bell' },
        { name: 'project-id-message', icon: 'mdi-email-outline' },
        { name: 'project-id-settings', icon: 'mdi-cog' },
        { name: 'project-id-help', icon: 'mdi-help-circle' }
      ]
    }
  },
  computed: {
    setDrawer: {
      get () { return this.drawer },
      set (val) { return this.$emit('update:drawer', val) }
    }
  }
}
</script>
