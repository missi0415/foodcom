<template>
  <layout-main #layout-main><!--eslint-disable-line-->
    <v-card
      v-for="post in posts"
      :key="post.id"
      class="mb-4 pl-1"
      outline
      @click="toShow(post.id)"
    >
    <v-card-text>
      page posts/index.vue
    </v-card-text>
      <v-row>
        <v-col class="d-flex">
          <v-img
            :src="src"
            max-height="60"
            max-width="60"
            contain
            style="border-radius: 50%"
            @click="showUser(post.user.id)"
          />
          <v-card-text>
            {{ post.user.id }}
            {{ post.user.name }}
            {{ post.id }}
          </v-card-text>
          <v-card-text
            class="text-right"
          >
            <v-icon size="16">
              mdi-update
            </v-icon>
            {{ $my.format(post.created_at) }}
          </v-card-text>
        </v-col>
      </v-row>
      <div>
        <v-card-title
          class="card-content"
        >
          {{ post.content }}
          コメント件数{{ post.comments.length }}
        </v-card-title>
      </div>
      <v-card-actions class="justify-space-around">
        <btn-new-comment
          :post="post"
        />
        <like-post
          :post="post"
        />
        <template v-if="post.user_id === currentUser.id">
          <btn-edit-post-in-index
            :post="post"
          />
          <btn-delete-post
            :post="post"
            :is-index="isIndex"
          />
        </template>
      </v-card-actions>
    </v-card>
  </layout-main>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import btnEditPostInIndex from '../../components/btn/btnEditPostInIndex.vue'
import btnDeletePost from '../../components/btn/btnDeletePost.vue'
import btnNewComment from '../../components/btn/btnNewcomment.vue'
import likePost from '../../components/btn/likePost.vue'
import layoutMain from '~/components/layout/loggedIn/layoutMain.vue'

export default {
  components: { layoutMain, btnEditPostInIndex, btnDeletePost, btnNewComment, likePost },
  data () {
    return {
      src: 'https://picsum.photos/200/200',
      isIndex: true
    }
  },
  computed: {
    ...mapGetters({
      posts: 'post/posts',
      btnColor: 'btn/color',
      currentUser: 'auth/data',
      isAuthenticated: 'auth/isAuthenticated',
      likePosts: 'like/likePosts'
    })
  },
  created () {
    this.fetchContents()
  },
  methods: {
    ...mapActions({
      flashMessage: 'flash/flashMessage',
      setPosts: 'post/setPosts',
      setPost: 'post/setPost',
      setLikePosts: 'like/setLikePosts',
      setLikeComments: 'like/setLikeComments',
      setUser: 'user/setUser'
    }),
    async fetchContents () {
      const url = '/api/v1/posts'
      await this.$axios.get(url)
        .then((res) => {
          this.setPosts(res.data)
          if (this.isAuthenticated) {
            this.setCurrentUserData()
          }
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    },
    async setCurrentUserData () {
      const url = `/api/v1/users/${this.currentUser.id}`
      await this.$axios.get(url)
        .then((res) => {
          console.log('setCurrentUserData', res.data)
          // api通信のusers/{id}で帰ってくる値をusershowで使うために変更したためにlikepostsが変わりエラーになった。
          this.setLikePosts(res.data.like_posts)
          this.setLikeComments(res.data.like_comments)
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    },
    async toShow (id) {
      const url = `/api/v1/posts/${id}`
      await this.$axios.get(url)
        .then((res) => {
          this.setPost(res.data)
          this.$router.push(`posts/${res.data.id}`)
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    },
    showUser (id) {
      console.log('showUser', id)
      this.$router.replace(`/users/${id}`)
    }
    // async showUser (id) {
    //   const url = `/api/v1/users/${id}`
    //   await this.$axios.get(url)
    //     .then((res) => {
    //       console.log('showUser', id)
    //       console.log('showUser', res.data)
    //       this.setUser(res.data)
    //       this.$router.push(`/users/${id}`)
    //     })
    //     .catch((err) => {
    //       // eslint-disable-next-line no-console
    //       console.error(err)
    //     })
    // }
  }
}
</script>
