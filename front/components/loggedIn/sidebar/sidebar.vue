<template>
  <v-card
    height="400"
    width="256"
    class="mx-auto"
  >
    <v-navigation-drawer
      app
      clipped
      mobile-breakpoint="960"
    >
          <v-list-item class="px-2">
        <v-list-item-avatar>
          <v-img src="https://randomuser.me/api/portraits/men/85.jpg"></v-img>
        </v-list-item-avatar>

        <v-list-item-title>John Leider</v-list-item-title>

        <v-btn
          icon
          @click.stop="mini = !mini"
        >
          <v-icon>mdi-chevron-left</v-icon>
        </v-btn>
      </v-list-item>

      <v-divider></v-divider>

      <v-list dense>
        <v-list-item
          v-for="item in items"
          :key="item.title"
          link
        >
          <v-list-item-icon>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>

  <!-- <v-app>
    <v-col
      cols="3"
      class="list"
    >
    sidbar.vue
      <v-list
        v-for="(menu, i) in menus"
        :key="`menu-btn-${i}`"
        nav
        rounded
      >
        <v-list-item
          two-line
          class="justify-center"
          @click="goHome"
        >
          <v-icon
            size="28"
            class="mr-5"
            v-text="menu.icon"
          />
          {{ $t(`menus.${menu.title}`) }}
        </v-list-item>
      </v-list> -->
    </v-navigation-drawer>
  </v-card>
</template>

<script>
import { mapActions } from 'vuex'
export default {
  data () {
    return {
      items: [
        { title: 'posts', icon: 'mdi-home' },
        { title: 'search', icon: 'mdi-magnify' },
        { title: 'notification', icon: 'mdi-bell' },
        { title: 'chat', icon: 'mdi-chat-processing-outline' },
        { title: 'follow', icon: 'mdi-account-details' },
        { title: 'follower', icon: 'mdi-account-details-outline' }
      ]
    }
  },
  methods: {
    ...mapActions({
      setPosts: 'post/setPosts'
    }),
    async goHome () {
      const url = '/api/v1/posts'
      await this.$axios.get(url)
        .then((res) => {
          this.setPosts(res.data)
          this.$router.push('/posts')
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    }
  }
}
</script>

<style scoped>
</style>
