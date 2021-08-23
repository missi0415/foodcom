<template>
  <layout-main #layout-main><!--eslint-disable-line-->
    <v-card
      class="mt-3 pl-1"
    >
      <v-row>
        <v-col class="d-flex">
          <v-img
            :src="src"
            max-height="60"
            max-width="60"
            contain
            style="border-radius: 50%"
          />
          <v-card-text>
            post.user.name
            <!-- {{ post.user.name }} -->
          </v-card-text>
          <v-card-text
            class="text-right"
          >
            <v-icon size="16">
              mdi-update
            </v-icon>
            コメント日時
            <!-- {{ $my.format(post.created_at) }} -->
          </v-card-text>
        </v-col>
      </v-row>
      <div>
        <v-card-title
          class="card-content"
        >
          <!-- {{ post.content }} -->
          投稿内容
        </v-card-title>
      </div>
        <v-card-actions>
        <v-btn
          text
        >
          いいね
          <v-icon>
            mdi-heart-outline
          </v-icon>
        </v-btn>
        <v-spacer />
        <!-- <btn-new-comment
        /> -->
        <v-spacer />
        <!-- <btn-edit-post /> -->
        <v-spacer />
        <!-- <btn-delete-post /> -->
      </v-card-actions>
    </v-card>
  </layout-main>
</template>

<script>
import layoutMain from '~/components/layout/loggedIn/layoutMain.vue'

export default {
  components: { layoutMain },
  data () {
    return {
      src: 'https://picsum.photos/200/200',
      isIndex: true
    }
  }
}
</script>
