<template>
  <div>
    <v-btn
      :color="btnColor"
      text
      rounded
      @click.prevent.stop="openDialog"
    >
      削除
      <v-icon v-text="'mdi-delete-empty'" />
    </v-btn>
    <v-dialog
      v-model="dialog"
      width="500"
    >
      <v-card>
        <v-card-title>
          削除します。よろしいですか？
        </v-card-title>
        <v-card-text>
          この操作は取り消せません。
        </v-card-text>
        <v-card-actions
        >
          <v-btn
            rounded
            color="info"
            class="text-left"
            @click="closeDialog"
          >
            キャンセル
          </v-btn>
          <v-spacer />
          <v-btn
            rounded
            color="error"
            class="text-right"
            @click="clickOK"
          >
            削除する
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  props: {
    post: {
      type: Object,
      // 親コンポーネントのposts.index.vueのpost in postsのなかのpostをpropsで受け取っている
      required: true
    },
    isIndex: {
      type: Boolean,
      required: true
    }
  },
  data () {
    return {
      dialog: false
    }
  },
  computed: {
    ...mapGetters({
      btnColor: 'btn/color'
    })
  },
  methods: {
    ...mapActions({
      setPosts: 'post/setPosts',
      flashMessage: 'flash/flashMessage'
    }),
    openDialog () {
      this.dialog = true
    },
    closeDialog () {
      this.dialog = false
    },
    clickOK () {
      this.$axios.$delete(`/api/v1/posts/${this.post.id}`)
        .then(() => {
          if (this.isIndex) {
            this.fetchContents()
          } else {
            this.$router.replace('/posts')
          }
          this.flashMessage({ message: '削除しました', type: 'primary', status: true })
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.log('投稿の削除に失敗', err)
        })
    },
    async fetchContents () {
      const url = '/api/v1/posts'
      await this.$axios.get(url)
        .then((res) => {
          this.setPosts(res.data)
        })
    }
  }
}
</script>
