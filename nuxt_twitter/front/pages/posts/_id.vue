<template>
  <layout-main #layout-main> <!--eslint-disable-line-->
    <v-card
      outlined
      elevation="15"
    >
    <v-card-text>
      page posts/_id.vue
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
            post{{ post.id }}_id.vue
            {{ post.user.name }}
          </v-card-title>
        </v-col>
      </v-row>
      <v-card-text>
        {{ post.content }}
        コメント数{{ post.comments.length }}
      </v-card-text>
      <v-divider />
        1リツイート0件のいいね
      <v-divider />
      <v-card-actions class="justify-space-around">
        <template>
          <v-btn
            :color="btnColor"
            text
          >
          <btn-show-post-comment
            :post="post"
          />
          </v-btn>
          {{ post.comments.length }}
        </template>
        <like-post
          :post="post"
        />
        <template v-if="post.user_id !== currentUser.id">
          <v-btn
            :color="btnColor"
            text
          >
            <v-icon v-text="'mdi-twitter-retweet'" />
          </v-btn>
        </template>
        <template v-if="post.user_id === currentUser.id">
          <v-spacer />
          <btn-edit-post-in-id
            :post="post"
          />
          <v-spacer />
          <btn-delete-post
            :post="post"
            :is-index="isIndex"
          />
        </template>
        <v-spacer />
      </v-card-actions>
    </v-card>
    <!-- 先頭カードここまで－－－ー -->
    <div>
      <comment-card
        v-for="(comment) in post.comments"
        :key="comment.content"
        :comment="comment"
        :isPostComment="true"
      />
    </div>
  </layout-main>
</template>

<script>
import { mapGetters } from 'vuex'
import btnDeletePost from '../../components/btn/btnDeletePost.vue'
import layoutMain from '../../components/layout/loggedIn/layoutMain.vue'
import btnShowPostComment from '../../components/btn/btnShowPostComment.vue'
import btnEditPostInId from '../../components/btn/btnEditPostInId.vue'
import likePost from '../../components/btn/likePost.vue'
import commentCard from '../../components/post/commentCard.vue'
export default {
  middleware: 'reload',
  components: {
    btnDeletePost,
    layoutMain,
    btnShowPostComment,
    btnEditPostInId,
    likePost,
    commentCard
  },
  data () {
    return {
      src: 'https://picsum.photos/200/200',
      isIndex: false
    }
  },
  computed: {
    ...mapGetters({
      post: 'post/post',
      postUser: 'post/user',
      currentUser: 'auth/data',
      btnColor: 'btn/color'
    })
  }
}
</script>
