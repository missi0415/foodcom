<template>
  <div>
    <v-card
      outlined
      elevation="15"
      @click="toShow(contentId.id)"
    >
      <v-card-subtitle>
        user/showCard.vue {{ user.name }}
      </v-card-subtitle>
      <v-row>
        <v-col class="d-flex">
          <v-img
            :src="src"
            max-height="70"
            max-width="70"
            style="border-radius: 50%;"
            contain
            class="ml-1 mt-1 mb-2"
          />
          <v-card-text>
            {{ content }}
          </v-card-text>
          <v-card-actions class="justify-space-around">
            <!-- コメントボタン -->
            <!-- <btn-new-comment-comment
              :comment="comment"
              @my-click="returnCommentscount"
            />
            {{ commentCount }}
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
            /> -->
          </v-card-actions>
        </v-col>
      </v-row>
    </v-card>
  </div>
</template>
<script>
import { mapGetters } from 'vuex'
// import btnDeleteComment from '../btn/btnDeleteComment.vue'
// import btnEditComment from '../btn/btnEditComment.vue'
// import btnNewCommentComment from '../btn/btnNewCommentComment.vue'
// import likeComment from '../btn/likeComment.vue'
export default {
  // components: { btnNewCommentComment, btnEditComment, btnDeleteComment, likeComment },
  props: {
    isPost: {
      type: Boolean,
      defalut: false,
      required: true
    },
    user: {
      type: Object,
      required: true
    },
    contentId: {
      type: Number,
      required: true
    },
    content: {
      type: String,
      required: true
    }
  },
  computed: {
    ...mapGetters({
      btnColor: 'btn/color'
    })
  },
  data () {
    return {
      src: 'https://picsum.photos/200/200',
      commentCount: 0
    }
  }
}
</script>
