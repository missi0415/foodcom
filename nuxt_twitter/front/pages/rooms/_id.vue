<template>
  <layout-main #layout-main> <!--eslint-disable-line-->
    <v-container>
      <v-row justify="space-around">
        <v-card>
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
          <v-card-text>
            相手user{{ user }}
          </v-card-text>
          <v-card-text>
            自分currentuser {{ currentUser }}
          </v-card-text>
          <v-card-text>
            firestoredata {{ messages }}
          </v-card-text>
          <v-card-text>
            chats {{ chats }}
          </v-card-text>
          <v-card-text>
            channel_id {{ channel_id }}
          </v-card-text>
          <v-list three-line>
            <v-list-item
              v-for="(item, i) in chats"
              :key="i"
            >
              <v-list-item-content>
                <v-list-item-title v-text="item.name"></v-list-item-title>
                <v-list-item-subtitle v-text="item.message"></v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </v-list>
          <v-form>
            <v-text-field
              v-model="message"
              label="メッセージを入力"
            >
            </v-text-field>
            <v-btn
              @click="onSubmit"
            >
            送信
            </v-btn>
          </v-form>
        </v-card>
      </v-row>
    </v-container>
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
      chats: [],
      channel_id: ''
    }
  },
  computed: {
    ...mapGetters({
      currentUser: 'auth/data',
      currentUserId: 'auth/currentUserId',
      isAuthenticated: 'auth/isAuthenticated'
      // chats: 'chats/chats'
    })
  },
  mounted () {
    this.fetchUser()
    setTimeout(() => {
      this.setChannelId()
      this.fetchMessage()
    }, 300)
  },
  methods: {
    async fetchUser () {
      const url = `/api/v1/users/${this.$route.params.id}`
      await this.$axios.get(url)
        .then((res) => {
          console.log('res', res)
          this.user.uid = res.data.user.uid
          this.user.id = res.data.user.id
          this.user.name = res.data.user.name
          this.user.avatar = res.data.user.avatar.url
          this.user.introduction = res.data.user.introduction
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
      this.fetchMessage()
      // this.scrollBottom()
    },
    resetForm () {
      this.message = ''
    },
    fetchMessage () {
      const chats = []
      firebase.firestore().collection('rooms').doc(this.channel_id).collection('chats').orderBy('createdAt', 'asc').get()
        .then((res) => {
          console.log('res', res)
          res.forEach((doc) => {
            chats.push(doc.data())
            this.chats = chats
            console.log('doc.data()', doc.data())
          })
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
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
    }
  }
}

</script>
