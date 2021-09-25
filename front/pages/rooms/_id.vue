<template>
  <layout-main #layout-main> <!--eslint-disable-line-->
    <v-card
      class="mx-auto"
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
          {{ user.name }}
        </v-toolbar-title>
      </v-app-bar>
      <v-divider />
      <!-- チャット画面 -->
      <v-list
        class="overflow-y-auto mx-auto "
        width="100%"
        max-height="600"
        max-width="1000"
        id="chat-height"
      >
      <v-list-item
        v-for="(msg, i) in chats"
        :key="i"
      >
          <v-col v-if="msg.userId != currentUser.uid">
            <div class="balloon_l">
              <div class="face_icon">
                <v-avatar
                  size="60"
                >
                  <img
                    :src="userAvatar"
                    contain
                  >
                </v-avatar>
              </div>
              <div>
                <p class="says">
                  {{ msg.message }}
                </p>
                <div
                  class="d-flex"
                >
                  <h6>{{ $moment(msg.timestamp).format('YYYY-MM-DD HH:mm') }}</h6>
                </div>
              </div>
            </div>
          </v-col>
          <v-col v-else>
            <div class="balloon_r">
              <div class="face_icon">
                <v-avatar
                  size="60"
                  contain
                >
                  <img
                    :src="currentUserAvatar"
                  >
                </v-avatar>
              </div>
              <div>
                <p class="says-current">
                  {{ msg.message }}
                </p>
                <div
                  class="d-flex justify-end"
                >
                  <h6>{{ $moment(msg.timestamp).format('YYYY-MM-DD HH:mm') }}</h6>
                </div>
              </div>
            </div>
          </v-col>
        </v-list-item>
      </v-list>
      <!-- form送信部分 -->
      <v-divider
        id="scroll-inner"
      />
      <div class="ma-0 pa-0 d-flex flex-row align-baseline">
        <v-text-field
          v-model="message"
          label="メッセージを入力"
          type="text"
          outlined
          hide-details="false"
          dense
          rounded
          class=" pa-2"
        />
        <v-btn
          class="ma-2 pa-2"
          outlined
          rounded
          color="myblue"
          @click="onSubmit"
        >
          送信
        </v-btn>
      </div>
    </v-card>
  </layout-main>
</template>

<script>
import { mapGetters } from 'vuex'
import layoutMain from '../../components/layout/loggedIn/layoutMain.vue'
import firebase from '~/plugins/firebase'
// import firebase from '~/plugins/firebase'
export default {
  components: {
    layoutMain
  },
  data () {
    return {
      user: { id: '', name: '', avatar: '', introduction: '', uid: '' },
      // rooms: [],
      message: '',
      messages: [],
      channel_id: '',
      userAvatar: '',
      currentUserAvatar: ''
    }
  },
  computed: {
    ...mapGetters({
      currentUser: 'auth/data',
      currentUserId: 'auth/currentUserId',
      isAuthenticated: 'auth/isAuthenticated',
      chats: 'chats/chats'
    })
  },
  mounted () {
    setTimeout(() => {
      this.fetchUser()
    }, 100)
  },
  watch: {
    storechats () {
      console.log('storeの値が変わりました')
      setTimeout(() => {
        this.scrollBottom()
      }, 100)
    }
  },
  destroyed () {
    this.$store.dispatch('chats/clear')
    if (this.unsubscribe) { this.unsubscribe() }
  },
  methods: {
    async fetchUser () {
      this.currentUserAvatar = this.currentUser.avatar.url
      const url = `/api/v1/users/${this.$route.params.id}`
      await this.$axios.get(url)
        .then((res) => {
          console.log('res', res)
          this.user.uid = res.data.user.uid
          this.user.id = res.data.user.id
          this.user.name = res.data.user.name
          this.user.avatar = res.data.user.avatar.url
          this.userAvatar = res.data.user.avatar.url
          this.user.introduction = res.data.user.introduction
          this.setChannelId()
          setTimeout(() => {
            this.scrollBottom()
          }, 50)
          const roomId = this.channel_id
          const unsubscribe = this.$store.dispatch('chats/subscribe', { roomId })
          return {
            unsubscribe
          }
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    },
    async onSubmit () {
      // 登録データを準備
      const chat = {
        userId: this.currentUser.uid,
        name: this.currentUser.name,
        message: this.message,
        createdAt: new Date()
      }
      // 投稿データをfirestoreに送信 //
      await firebase.firestore()
        .collection('rooms')
        .doc(this.channel_id)
        .collection('chats')
        .add(chat)
      this.resetForm()
      setTimeout(() => {
        this.scrollBottom()
      }, 100)
    },
    resetForm () {
      this.message = ''
    },
    pageBack () {
      this.$router.go(-1)
    },
    setChannelId () {
      if (this.user.uid > this.currentUser.uid) {
        this.channel_id = this.user.uid + '-' + this.currentUser.uid
      } else {
        this.channel_id = this.currentUser.uid + '-' + this.user.uid
      }
    },
    scrollBottom () {
      const chatBack = document.getElementById('chat-height')
      chatBack.scrollTop = chatBack.scrollHeight
    }
  }
}

</script>
<style scoped>
.balloon_l,
.balloon_r {
  margin: 10px 0;
  display: flex;
  justify-content: flex-start;
  align-items: flex-start;
}
.balloon_r {
  justify-content: flex-end;
}
.face_icon img {
  width: 80px;
  height: auto;
}
.balloon_r .face_icon {
  margin-left: 25px;
}
.balloon_l .face_icon {
  margin-right: 25px;
}
.balloon_r .face_icon {
  order: 2 !important;
}
.says {
  max-width: 300px;
  display: flex;
  flex-wrap: wrap;
  position: relative;
  padding: 10px;
  border-radius: 12px;
  background: #E3F2FD;
  box-sizing: border-box;
  margin: 0 !important;
  line-height: 1.5;
  /*   align-items: center; */
}
.says-current {
  max-width: 300px;
  word-break:break-all;
  display: flex;
  flex-wrap: wrap;
  position: relative;
  padding: 8px;
  border-radius: 12px;
  background: #64B5F6;
  box-sizing: border-box;
  margin: 0 !important;
  line-height: 1.5;
  /*   align-items: center; */
}
.says p {
  margin: 8px 0 0 !important;
}
.says p:first-child {
  margin-top: 0 !important;
}
.says:after {
  content: "";
  position: absolute;
  border: 10px solid transparent;
  margin-top: -3px;
}
.says-current:after {
  content: "";
  position: absolute;
  border: 10px solid transparent;
  margin-top: -3px;
}
.balloon_l .says:after {
  left: -26px;
  border-right: 22px solid #E3F2FD;
}
.balloon_r .says-current:after {
  right: -26px;
  border-left: 22px solid #64B5F6;
}
</style>
