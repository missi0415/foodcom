<template>
  <div>
    <v-tooltip bottom>
      <template #activator="{ on, attrs }">
        <template v-if="!isLike">
          <v-btn
            icon
            class="btn-like"
            v-bind="attrs"
            v-on="on"
            @click.prevent.stop="likePost"
          >
            <v-icon v-text="'mdi-heart-outline'" />
          </v-btn>
        </template>
        <template v-else>
          <v-btn
            icon
            class="btn-like"
            v-bind="attrs"
            v-on="on"
            color="#ff007f"
            @click.prevent.stop="disLikePost"
          >
            <v-icon v-text="'mdi-heart'" />
          </v-btn>
        </template>
      </template>
        <span>いいね</span>
      </v-tooltip>
    <template v-if="likeCount > 0 ">
      {{ likeCount }}
    </template>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
export default {
  props: {
    post: {
      type: Object,
      required: true
    },
    likePosts: {
      type: Array,
      required: true
    }
  },
  data () {
    return {
      likePostUserIds: [],
      newLike: {},
      isLike: false
    }
  },
  computed: {
    ...mapGetters({
      currentUser: 'auth/data',
      btnColor: 'btn/color'
    }),
    likeCount () {
      return this.likePostUserIds.length
    }
  },
  created () {
    setTimeout(() => {
      this.setLikePostUserIds()
    }, 500)
  },
  methods: {
    ...mapActions({
      flashMessage: 'flash/flashMessage'
    }),
    async likePost () {
      this.newLike.user_id = this.currentUser.id
      this.newLike.post_id = this.post.id
      const url = '/api/v1/like_posts'
      await this.$axios.post(url, this.newLike)
        .then(() => {
          this.likeCountIncrement()
          this.likePostUserIds.push(this.currentUser.id)
          this.isLike = true
          this.flashMessage({ message: 'いいねしました', type: 'success', status: true })
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    },
    disLikePost () {
      const url = '/api/v1/like_posts/delete'
      this.$axios.$delete(url, {
        data: {
          user_id: this.currentUser.id,
          post_id: this.post.id
        }
      })
        .then(() => {
          this.likeCountDecrement()
          this.isLike = false
          const th = this.likePostUserIds.indexOf(this.currentUser.id)
          this.likePostUserIds.splice(th, 1)
          this.flashMessage({ message: 'いいねを取り消しました', type: 'error', status: true })
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    },
    setLikePostUserIds () {
      for (let i = 0; i < this.likePosts.length; i++) {
        this.likePostUserIds.push(this.likePosts[i].user_id)
      }
      this.searchMyLike()
    },
    searchMyLike () {
      if (this.likePostUserIds.includes(this.currentUser.id)) {
        this.isLike = true
      }
    },
    likeCountIncrement () {
      this.$emit('likeCountIncrement')
    },
    likeCountDecrement () {
      this.$emit('likeCountDecrement')
    }
  }
}
</script>
<style scoped>
  .btn-like:hover {
    color: #ff007f;
  }
</style>
