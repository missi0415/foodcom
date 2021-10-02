<template>
  <layout-main #layout-main> <!--eslint-disable-line-->
    <v-card
      class="ma-1"
      hover
      outlined
    >
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
          投稿
        </v-toolbar-title>
      </v-app-bar>
      <v-divider/>
      <v-list-item
        class="grow"
      >
        <v-list-item-avatar
          size=60
        >
          <v-img
            :src="avatarImage"
            class="img"
            contain
            lazy-src
            @click.prevent.stop="toShowUser(post.user_id)"
          />
        </v-list-item-avatar>
        <v-list-item-content>
          <v-list-item-title>
            {{ post.user.name }}
          </v-list-item-title>
        </v-list-item-content>
        <v-row
          align="center"
          justify="end"
          class="mr-1"
        >
          <caption>
            <v-icon size="15">
              mdi-update
            </v-icon>
              {{ time }}
          </caption>
        </v-row>
      </v-list-item>
      <v-row>
        <v-col>
          <v-card-text>
            {{ post.content}}
          </v-card-text>
          <v-img
            :src="postImage"
            max-height="200"
            max-width="200"
            contain
          />
        </v-col>
      </v-row>
      <v-divider />
        <v-row>
          <v-col class="d-flex text-center">
            <v-card-text>
              0 件のリツイート
            </v-card-text>
            <v-card-text>
              {{ commentsCount }} 件のコメント
            </v-card-text>
            <v-card-text>
              {{ likeCount }} 件のいいね
            </v-card-text>
          </v-col>
        </v-row>
      <v-divider />
      <v-card-actions class="justify-space-around">
          <btn-new-comment
            :avatarImage="avatarImage"
            :post="post"
            :is-index="isIndex"
            @fetchPost="fetchPost"
          />
          <like-post
            :post="post"
            :like-posts="likePosts"
            :like-post-count="likeCount"
            @likeCountIncrement="likeCountIncrement"
            @likeCountDecrement="likeCountDecrement"
          />
        <template v-if="post.user_id === currentUserId">
          <btn-edit-post
            :post="post"
            :is-index="isIndex"
            @fetchPost="fetchPost"
          />
          <btn-delete-post
            :post="post"
            :is-index="isIndex"
            @fetchPost="fetchPost"
          />
        </template>
      </v-card-actions>
    </v-card>
    <!-- 先頭カードここまで－－－ー -->
    <div>
      <comment-card
        v-for="comment in post.comments"
        :key="comment.id"
        :content-id="comment.id"
        @fetchPost="fetchPost"
      />
    </div>
  </layout-main>
</template>

<script>
import { mapGetters } from 'vuex'
import likePost from '../../components/btn/likePost.vue'
import commentCard from '../../components/post/commentCard.vue'
import btnNewComment from '../../components/btn/btnNewComment.vue'
import layoutMain from '../../components/layout/loggedIn/layoutMain.vue'
export default {
  components: {
    likePost,
    commentCard,
    layoutMain,
    btnNewComment
  },
  data () {
    return {
      src: 'https://picsum.photos/200/200',
      isIndex: false,
      post: { user: {}, comments: {} },
      likePosts: [],
      commentsCount: 0,
      likeCount: 0,
      time: '',
      loginUser: {},
      postImage: '',
      avatarImage: ''
    }
  },
  computed: {
    ...mapGetters({
      currentUser: 'auth/data',
      currentUserId: 'auth/currentUserId',
      btnColor: 'btn/color'
    })
  },
  created () {
    this.fetchPost()
  },
  methods: {
    async fetchPost () {
      const url = `/api/v1/posts/${this.$route.params.id}`
      console.log(url)
      await this.$axios.get(url)
        .then((res) => {
          console.log('then.res', res)
          this.avatarImage = res.data.user.avatar.url
          this.post = res.data.post
          this.postImage = res.data.post.image.url
          this.post.user = res.data.user
          this.post.comments = res.data.comments
          this.commentsCount = res.data.comments.length
          this.likePosts = res.data.like_posts
          this.likeCount = res.data.like_posts.length
          this.time = this.$my.format(this.post.created_at)
        })
    },
    likeCountIncrement () {
      this.likeCount++
    },
    likeCountDecrement () {
      this.likeCount--
    },
    toShowUser (id) {
      this.$router.push(`/users/${id}`)
    },
    loginUserSet () {
      this.loginUser = this.currentUser
    },
    pageBack () {
      this.$router.go(-1)
    }
  }
}
</script>
