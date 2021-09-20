<template>
  <layout-main #layout-main><!--eslint-disable-line-->
    <v-card>
      <v-app-bar
        flat
        color="rgba(0, 0, 0, 0)"
      >
        <v-btn
          icon
          large
          class="mr-5"
          @click="pageBack"
        >
          <v-icon>mdi-arrow-left</v-icon>
        </v-btn>
        <v-toolbar-title>
          検索
        </v-toolbar-title>
      </v-app-bar>
      <v-divider />
      <v-form>
        <v-container>
          <v-row
            class="pt-7 pl-5 pr-5"
          >
            <v-text-field
              v-model="keyword"
              outlined
              rounded
              label="検索ワードを入力"
              append-outer-icon="mdi-magnify"
              @click:append-outer="search"
            >
            </v-text-field>
          </v-row>
        </v-container>
      </v-form>
      <v-divider />
      <v-tabs
        v-model="tab"
        color="primary accent-10"
        grow
      >
        <v-tab>投稿</v-tab>
        <v-tab>ユーザー</v-tab>
      </v-tabs>
      <v-tabs-items v-model="tab">
        <v-tab-item>
          ポスト
          <comment-card
            v-for="post in posts"
            :key="post.id"
            :content-id="post.id"
          />
          {{ posts }}
        </v-tab-item>
        <v-tab-item>
          ユーザー
          <user-follow-card
            v-for="user in users"
            :key="user.id"
            :user="user"
          />
          {{ users }}
          {{ follwingUsers }}
        </v-tab-item>
      </v-tabs-items>
    </v-card>
  </layout-main>
</template>
<script>
import { mapGetters } from 'vuex'
import layoutMain from '../../components/layout/loggedIn/layoutMain.vue'
import commentCard from '../../components/post/commentCard.vue'
import userFollowCard from '../../components/user/userFollowCard.vue'
export default {
  components: {
    layoutMain,
    commentCard,
    userFollowCard
  },
  data () {
    return {
      tab: null,
      keyword: '',
      loading: false,
      posts: [],
      users: [],
      follwingUsers: []
    }
  },
  computed: {
    ...mapGetters({
      currentUserId: 'auth/currentUserId'
    })
  },
  mounted () {
    setTimeout(() => {
      this.fetchFolowingUser()
    }, 100)
  },
  methods: {
    search () {
      this.loading = true
      const url = 'api/v1/search'
      this.$axios.get(url, { params: { keyword: this.keyword } })
        .then((res) => {
          console.log(res.data)
          this.posts = res.data.posts
          this.users = res.data.users
        })
        .catch((err) => {
          console.log(err)
        })
    },
    fetchFolowingUser () {
      const url = `api/v1/users/${this.currentUserId}/following_users`
      this.$axios.get(url)
        .then((res) => {
          console.log('follwingusers', res)
          this.follwingUsers = res.data.following_users
        })
        .catch((err) => {
          console.log(err)
        })
    },
    pageBack () {
      this.$router.go(-1)
    }
  }
}
</script>
