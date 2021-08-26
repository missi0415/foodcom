<template>
  <div>
    <v-card
      outlined
      elevation="15"
      @click="toShow(comment.id)"
    >
      <v-card-text>
        postCommentCard.Vue
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
          />
          <v-card-title>
            {{ comment.user.name }}
          </v-card-title>
        </v-col>
      </v-row>
      <v-card-text>
        {{ comment.content }}
      </v-card-text>
      <v-card-actions>
        <v-spacer />
        <btn-new-comment-comment
          :comment="comment"
          @my-click="returnCommentscount"
        />
        {{ commentCount }}
        <v-spacer />
        <v-btn
            :color="btnColor"
            text
        >
          <v-icon v-text="'mdi-twitter-retweet'" />
        </v-btn>
        <v-spacer />
        <v-btn
            :color="btnColor"
            text
        >
          <v-icon v-text="'mdi-twitter-retweet'" />
        </v-btn>
        <v-spacer />
      </v-card-actions>
    </v-card>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import btnNewCommentComment from '../btn/btnNewCommentComment.vue'
export default {
  components: { btnNewCommentComment },
  props: {
    comment: {
      type: Object,
      required: true
    }
  },
  data () {
    return {
      src: 'https://picsum.photos/200/200',
      commentCount: 0
    }
  },
  mounted () {
    this.returnCommentscount(this.comment.id)
    console.log('postcommentcard-mounted returnCommentscounts', this.comment.id)
  },
  computed: {
    ...mapGetters({
      comments: 'comment/comments',
      currentUser: 'auth/data',
      btnColor: 'btn/color'
    })
  },
  methods: {
    ...mapActions({
      setComments: 'comment/setComments',
      setComment: 'comment/setComment'
    }),
    async toShow (id) {
      const url = `/api/v1/comments/${id}`
      await this.$axios.get(url)
        .then((res) => {
          this.setComment(res.data)
          this.searchAndSetComments(res.data.id)
          console.log(res)
          this.$router.push(`/comments/${res.data.id}`)
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    },
    async searchAndSetComments (id) {
      const url = `api/v1/search_comments/${id}`
      await this.$axios.get(url)
        .then((res) => {
          this.setComments(res.data)
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    },
    async returnCommentscount (id) {
      console.log('components-postCommentCard.vue run returnCommentscount', this.comments)
      const url = `api/v1/search_comments/${id}`
      await this.$axios.get(url)
        .then((res) => {
          this.commentCount = res.data.length
          console.log(res.data.length)
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    }
  }
}
</script>
