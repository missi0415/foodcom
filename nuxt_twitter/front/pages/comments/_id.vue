<template>
  <layout-main #layout-main> <!--eslint-disable-line-->
    <v-card
      outlined
      elevation="15"
    >
      <v-card-text>
        page comments/_id.vue
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
            comment{{ comment.user.name }}_id.vue
          </v-card-title>
        </v-col>
      </v-row>
      <v-card-text>
        コメント件数は{{ comments.commnt_id }}
        commnt.id:{{ comment }}
      </v-card-text>
      <v-divider />
        2リツイート0件のいいね
      <v-divider />
      <v-card-actions>
        <v-spacer />
        <btn-new-comment-comment
          :comment="comment"
          :comment-index="0"
          @my-click="searchAndSetComments"
        />
          {{ comments.length }}
        <v-btn
            :color="btnColor"
            text
          >
            <v-icon v-text="'mdi-twitter-retweet'" />
        </v-btn>
        <template v-if="comment.user_id !== currentUser.id">
          <v-spacer />
          <v-btn
            :color="btnColor"
            text
          >
            <v-icon v-text="'mdi-twitter-retweet'" />
          </v-btn>
        </template>
        <v-spacer />
        <v-btn
          :color="btnColor"
          text
        >
          <v-icon v-text="'mdi-heart-outline'" />
        </v-btn>
        <template v-if="comment.user_id === currentUser.id">
          <v-spacer />
          <btn-edit-comment
            :comment="comment"
            :isPostComment="false"
          />
          <v-spacer />
          <btn-delete-comment
            :comment="comment"
            :isPostComment="false"
          />
        </template>
        <v-spacer />
      </v-card-actions>
    </v-card>
    <!-- 先頭カードここまで－－－ー -->
    <div>
      <comment-card
        v-for="(comment) in comments"
        :key="comment.content"
        :comment="comment"
        :isPostComment="false"
      />
    </div>
  </layout-main>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import btnEditComment from '../../components/btn/btnEditComment.vue'
import btnNewCommentComment from '../../components/btn/btnNewCommentComment.vue'
import layoutMain from '../../components/layout/loggedIn/layoutMain.vue'
import commentCard from '../../components/post/commentCard.vue'
export default {
  components: {
    layoutMain,
    btnNewCommentComment,
    btnEditComment,
    commentCard
  },
  data () {
    return {
      isPostComment: false,
      src: 'https://picsum.photos/500/500'
    }
  },
  computed: {
    ...mapGetters({
      comments: 'comment/comments',
      comment: 'comment/comment',
      currentUser: 'auth/data',
      btnColor: 'btn/color'
    })
  },
  methods: {
    ...mapActions({
      setComments: 'comment/setComments',
      setComment: 'comment/setComment'
    }),
    async searchAndSetComments (id) {
      console.log('components-comments-id.vue run searchAndSetComments', this.comments)
      const url = `api/v1/search_comments/${id}`
      await this.$axios.get(url)
        .then((res) => {
          this.setComments(res.data)
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    }
  }
}
</script>
