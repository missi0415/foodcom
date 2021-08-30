<template>
  <v-navigation-drawer
    v-model="setDrawer"
    app
    clipped
    :mini-variant="$vuetify.breakpoint.md || $vuetify.breakpoint.sm || $vuetify.breakpoint.xs"
    mini-variant-width="112"
    mobile-breakpoint="0"
    class="pa-3 justify-center"
  >
  <!-- {{ $vuetify.breakpoint.md }} -->
    <v-list
      rounded
    >
      <v-list-item
        v-for="item in items"
        :key="item.title"
        link
        class="pa-1 justify-center"

      >
        <v-list-item-action
        >
          <v-icon
            size="38px"
            class="justify-center"
          >
          {{ item.icon }}
          </v-icon>
        </v-list-item-action>
        <v-list-item-content>
          <v-list-item-title>{{ item.title }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <div
        class="my-2"
        v-if="$vuetify.breakpoint.md || $vuetify.breakpoint.sm || $vuetify.breakpoint.xs"
      >
        <v-btn
          color="blue"
          fab
          x-large
          dark
        >
          <v-icon>mdi-pencil</v-icon>
        </v-btn>
      </div>
      <div
        v-else
        class="my-2"
      >
        <v-btn
          color="blue"
          x-large
          rounded
          dark
          block
        >
          ツイートする
        </v-btn>
      </div>
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
      mini: false,
      items: [
        { title: 'ホーム', icon: 'mdi-home' },
        { title: '検索', icon: 'mdi-magnify' },
        { title: '通知', icon: 'mdi-bell-outline' },
        { title: 'メッセージ', icon: 'mdi-chat-processing-outline' },
        { title: 'フォロー', icon: 'mdi-account-details' },
        { title: 'フォロワー', icon: 'mdi-account-details-outline' }
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
