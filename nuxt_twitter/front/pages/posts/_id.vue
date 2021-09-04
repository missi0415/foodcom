<template>
  <layout-main #layout-main> <!--eslint-disable-line-->
    <v-card
      outlined
      elevation="15"
    >
    <v-card-text>
      page posts/_id.vuesdfsdfd
    </v-card-text>
      <v-row>
        <v-col class="d-flex">
          <v-img
            :src="src"
            max-height="70"
            max-width="70"
            style="border-radius: 50%;"
            contain
            class="ml-3 mt-3"
            @click.prevent.stop="toShowUser(post.user_id)"
          />
          <v-card-title>
            {{ user.name }}
          </v-card-title>
        </v-col>
      </v-row>
      <v-card-text>
        {{ post }}
      </v-card-text>
      <v-img
        :src="postImage"
        max-height="200"
        max-width="200"
        contain
      />
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
            :post="post"
            :comments="comments"
            :is-index="isIndex"
            @fetchPost="fetchPost"
          />
          <template v-if="post.user_id !== currentUserId">
            <v-btn
              :color="btnColor"
              text
            >
              <v-icon v-text="'mdi-twitter-retweet'" />
            </v-btn>
          </template>
          <like-post
            :post="post"
            :like-posts="likePosts"
            :like-post-count="likeCount"
            @likeCountIncrement="likeCountIncrement"
            @likeCountDecrement="likeCountDecrement"
          />
        <template v-if="post.user_id !== currentUserId">
          <v-btn
            :color="btnColor"
            text
          >
            <v-icon v-text="'mdi-twitter-retweet'" />
          </v-btn>
        </template>
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
        v-for="(comment) in comments"
        :key="comment.content"
        :comment="comment"
        :user="user"
        :isPostComment="true"
      />
    </div>
  </layout-main>
</template>

<script>
import { mapGetters } from 'vuex'
// import btnDeletePost from '../../components/btn/btnDeletePost.vue'
// import btnShowPostComment from '../../components/btn/btnShowPostComment.vue'
// import btnEditPostInId from '../../components/btn/btnEditPostInId.vue'
import likePost from '../../components/btn/likePost.vue'
import commentCard from '../../components/post/commentCard.vue'
import BtnNewComment from '../../components/btn/btnNewComment.vue'
import layoutMain from '../../components/layout/loggedIn/layoutMain.vue'
export default {
  components: {
    // btnDeletePost,
    // btnShowPostComment,
    // btnEditPostInId,
    likePost,
    commentCard,
    // BtnNewComment,
    layoutMain,
    BtnNewComment
  },
  data () {
    return {
      src: 'https://picsum.photos/200/200',
      isIndex: false,
      post: {},
      user: {},
      comments: [],
      likePosts: [],
      commentsCount: 0,
      likeCount: 0,
      time: '',
      loginUser: {},
      postImage: ''
    }
  },
  computed: {
    ...mapGetters({
      currentUser: 'auth/data',
      currentUserId: 'auth/currentUserId',
      btnColor: 'btn/color'
    })
  },
  mounted () {
    this.fetchPost()
  },
  methods: {
    async fetchPost () {
      const url = `/api/v1/posts/${this.$route.params.id}`
      console.log(url)
      await this.$axios.get(url)
        .then((res) => {
          console.log('then.res', res)
          this.post = res.data.post
          this.postImage = res.data.post.image.url
          this.user = res.data.user
          this.comments = res.data.comments
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
    }
  }
}
</script>
<style scoped>
</style>
