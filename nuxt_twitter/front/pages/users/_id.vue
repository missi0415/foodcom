<template>
  <layout-main #layout-main><!--eslint-disable-line-->
  page users/id.vue
  {{ user }}
    <v-container>
    <v-row justify="space-around">
      <v-card>
        <v-app-bar
          flat
          color="rgba(0, 0, 0, 0)"
        >
          <v-btn
            icon
            large
            class="pr-5"
          >
            <v-icon>mdi-arrow-left</v-icon>
          </v-btn>
          <v-toolbar-title>{{ user.name }}</v-toolbar-title>
          <v-spacer></v-spacer>
          <v-btn
            icon
            large
          >
            <v-icon>mdi-dots-vertical</v-icon>
          </v-btn>
        </v-app-bar>
        <v-img
          height="200px"
          src="https://cdn.pixabay.com/photo/2020/07/12/07/47/bee-5396362_1280.jpg"
        >
        </v-img>
          <v-card-title>
            <v-avatar size="56">
              <img
                alt="user"
                src="https://cdn.pixabay.com/photo/2020/06/24/19/12/cabbage-5337431_1280.jpg"
              >
            </v-avatar>
            <p class="ml-3 mt-3">
              {{ user.name }}
            </p>
            <v-spacer></v-spacer>
            <div class="text-center">
              <v-btn
                rounded
                color="info"
                outlined
                dark
              >
                フォローする
              </v-btn>
            </div>
          </v-card-title>

        <v-card-title>
          <div class="font-weight-bold ml-8 mb-2">
            よろしくおねがいします
          </div>
        </v-card-title>
      </v-card>
    </v-row>
  </v-container>
  </layout-main>
</template>
<script>
import { mapGetters } from 'vuex'
import layoutMain from '../../components/layout/loggedIn/layoutMain.vue'
export default {
  components: {
    layoutMain
  },
  computed: {
    ...mapGetters({
      btnColor: 'btn/color',
      currentUser: 'auth/data',
      user: 'user/user',
      posts: 'post/posts',
      isAuthenticated: 'auth/isAuthenticated',
      likePosts: 'like/likePosts'
    })
  }
}
</script>
