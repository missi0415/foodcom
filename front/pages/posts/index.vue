<template>
  <layout-main #layout-main><!--eslint-disable-line-->
    <new-post-index
      @fetchPost="fetchPost"
    />
    <comment-card
      v-for="post in posts"
      :key="post.id"
      :content-id="post.id"
      @fetchPost="fetchPost"
    />
    <VueInfiniteLoading
      ref="infiniteLoading"
      spinner="bubbles"
      :identifier="infiniteId"
      @infinite="infiniteHandler"
    >
      <span slot="no-more">-----投稿は以上です-----</span>
      <span slot="no-results">----投稿がありません----</span>
    </VueInfiniteLoading>
  </layout-main>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import NewPostIndex from '../../components/post/newPostIndex.vue'
import CommentCard from '../../components/post/commentCard.vue'
import LayoutMain from '~/components/layout/loggedIn/layoutMain.vue'

export default {
  components: {
    LayoutMain,
    NewPostIndex,
    CommentCard
  },
  data () {
    return {
      src: 'https://picsum.photos/200/200',
      isIndex: true,
      posts: [],
      page: 1,
      infiniteId: 0
    }
  },
  computed: {
    ...mapGetters({
      btnColor: 'btn/color',
      currentUser: 'auth/data',
      currentUserId: 'auth/currentUserId',
      isAuthenticated: 'auth/isAuthenticated',
      submitPost: 'post/submitPost'
    })
  },
  created () {
    this.fetchPost()
  },
  watch: {
    submitPost (val) {
      if (val) {
        this.fetchPost()
        this.setSubmitPost(false)
      }
    }
  },
  methods: {
    ...mapActions({
      flashMessage: 'flash/flashMessage',
      setSubmitPost: 'post/setSubmitPost'
    }),
    infiniteHandler () {
      this.page += 1
      this.$axios.get('/api/v1/posts', { params: { page: this.page } })
        .then((res) => {
          const posts = res.data.posts
          setTimeout(() => {
            if (posts.length !== 0) {
              this.posts.push(...posts)
              this.$refs.infiniteLoading.stateChanger.loaded()
            } else {
              this.$refs.infiniteLoading.stateChanger.complete()
            }
          }, 1000)
        })
    },
    async fetchPost () {
      this.resetHandler()
      this.returnTop()
      const url = '/api/v1/posts'
      await this.$axios.get(url)
        .then((res) => {
          this.posts = res.data.posts
          this.$vuetify.goTo(0)
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    },
    toShowPost (id) {
      this.$router.push(`/posts/${id}`)
    },
    toShowUser (id) {
      this.$router.push(`/users/${id}`)
    },
    resetHandler () {
      this.page = 1
      this.infiniteId += 1
    },
    returnTop () {
      window.scrollTo({
        top: 0,
        behavior: 'auto'
      })
    }
  }
}
</script>
