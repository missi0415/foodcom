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
        {{ comment }}
      </v-card-text>
      <v-card-actions class="justify-space-around">
        <!-- コメントボタン -->
        <!-- <btn-new-comment-comment
          :comment="comment"
        /> -->
        <like-comment
          :comment="comment"
        />
        <v-btn
          :color="btnColor"
          text
        >
          <v-icon v-text="'mdi-twitter-retweet'" />
        </v-btn>
        <btn-edit-comment
          :comment="comment"
          :isPostComment="isPostComment"
        />
        <btn-delete-comment
          :comment="comment"
          :isPostComment="isPostComment"
        />
      </v-card-actions>
    </v-card>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import btnDeleteComment from '../btn/btnDeleteComment.vue'
import btnEditComment from '../btn/btnEditComment.vue'
import likeComment from '../btn/likeComment.vue'
export default {
  components: {  btnEditComment, btnDeleteComment, likeComment },
  props: {
    isPostComment: {
      type: Boolean,
      required: true
    },
    comment: {
      type: Object,
      required: true
    },
    user: {
      type: Object,
      required: true
    }
  },
  data () {
    return {
      isIndex: true,
      src: 'https://picsum.photos/500/500'
    }
  },
  computed: {
    ...mapGetters({
      currentUser: 'auth/data',
      isAuthenticated: 'auth/isAuthenticated',
      btnColor: 'btn/color'
    })
  },
  methods: {
    toShowComment (id) {
      this.$router.push(`/comments/${id}`)
    },
    toShowUser (id) {
      this.$router.push(`/users/${id}`)
    },
    fetchPost () {
      this.$emit('fetchPost')
    }
  }
}
</script>
