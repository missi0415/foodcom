<template>
  <v-card
    outlined
    class="ma-1"
    hover
  >
    <v-list-item
      class="grow"
    >
      <v-list-item-avatar
        size=60
      >
        <v-img
          :src="user.avatar.url"
          class="img"
          contain
          lazy-src
          @click="toShowUser(user.id)"
        />
      </v-list-item-avatar>
      <v-list-item-content>
        <v-list-item-title>
          {{ user.name }}
        </v-list-item-title>
      </v-list-item-content>
      <v-row
        align="center"
        justify="end"
        class="mr-1"
      >
      <template v-if="user.id !== currentUserId">
        <div class="text-center">
          <v-btn
            v-if="follow"
            rounded
            :color="color"
            @click="unfollowUser"
            @mouseover="mouseover"
            @mouseleave="mouseleave"
          >
            {{ message }}
          </v-btn>
          <v-btn
            v-else
            rounded
            color="info"
            outlined
            dark
            @click="followUser"
          >
            <v-icon class="mr-2">mdi-account-plus</v-icon>
              フォロー
          </v-btn>
        </div>
      </template>
      </v-row>
    </v-list-item>
    <v-card-title>
      <div class="ml-8 mb-2">
        {{ user.introduction}}
      </div>
    </v-card-title>
  </v-card>
</template>
<script>
import { mapGetters, mapActions } from 'vuex'
export default {
  props: {
    user: {
      type: Object,
      required: true
    }
  },
  data () {
    return {
      src: 'https://picsum.photos/500/500',
      color: 'info white--text',
      message: 'フォロー中',
      follow: true
    }
  },
  computed: {
    ...mapGetters({
      currentUser: 'auth/data',
      currentUserId: 'auth/currentUserId',
      isAuthenticated: 'auth/isAuthenticated'
    })
  },
  methods: {
    ...mapActions({
      flashMessage: 'flash/flashMessage'
    }),
    toShowUser (id) {
      this.$router.push(`/users/${id}`)
    },
    mouseover () {
      this.color = 'red white--text'
      this.message = 'フォロー解除'
    },
    mouseleave () {
      this.color = 'info white--text'
      this.message = 'フォロー中'
    },
    followUser () {
      this.$axios.post('/api/v1/relationships', {
        user_id: this.currentUserId,
        follow_id: this.user.id
      })
        .then((res) => {
          console.log('フォローしました', res)
          this.flashMessage({ message: 'フォローしました', type: 'success', status: true })
          this.$axios.get(`/api/v1/users/${this.$route.params.id}`)
            .then((res) => {
              this.follow = true
              console.log('フォロー後レス', res)
              this.follower_user = res.data.follower_user
              // 今現在表示しているユーザーのフォロワー数が自分がフォローするかしないで減る
            })
        })
        .catch((err) => {
          console.log('フォローエラー', err)
        })
    },
    unfollowUser () {
      this.$axios.delete('/api/v1/relationships/delete', {
        params: {
          user_id: this.currentUserId,
          follow_id: this.user.id
        }
      })
        .then(() => {
          console.log('フォロー外しました')
          this.follow = false
          this.flashMessage({ message: 'フォロー解除しました', type: 'success', status: true })
        })
    }
  }
}
</script>
