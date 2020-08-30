<!--pages/twitter/detail.qml-->
<view class="container">
  <view class="detail-title">
    <text>{{detail.title.rendered}}</text>
  </view>
  <view class="detail-meta">
    <view class="meta-box">
      <text class="meta-text-tag">原创</text>
    </view>
    <view class="meta-box" qq:if="{{detail.meta.author}}">
      <text>{{detail.meta.author}}</text>
    </view>
    <navigator url="/pages/twitter/twitter" class="meta-box" hover-class="navigator-hover">
      <text class="meta-text-color">艾码汇</text>
    </navigator>
    <view class="meta-box">
      <text>{{detail.time}}</text>
    </view>
  </view>
  <view class="detail-content">
    <view class="wxParse-p">
      <image bindtap="wxParseImgTap" class="wxParse-img" data-src="{{detail.meta.thumbnail}}" mode="widthFix" src="{{detail.meta.thumbnail}}"></image>
    </view>
    <view class="wxParse-p">
      <view class="WxEmojiView wxParse-inline">
        <text>{{detail.excerpt.rendered}}</text>
      </view>
    </view>
  </view>
  <view class="detail-footer">
    <view class="detail-foot-meta" qq:if="{{detail.meta.source}}">
      <view data-link="/pages/view/view?url={{detail.meta.source}}" class="meta-box" bindtap="bindCopyLink">
        <text class="meta-text-color">阅读原文</text>
      </view>
    </view>
    <view class="detail-foot-meta">
      <button class="meta-text-color" open-type="share" hover-class="none"><text class="icon-share"></text> 分享</button>
    </view>
  </view>
</view>
<view class="comments-box">
  <view class="comments-title">
    <view class="comments-meta-bar">
      <text>精选留言</text>
    </view>
    <view class="comments-meta-bar">
      <text class="meta-text-color" bindtap="bindComment">写留言</text>
    </view>
  </view>
  <view class="comments-content">
    <view class="nocomments" qq:if="{{comments.length == 0}}">
      <text>尚未有人抢沙发!</text>
      <text class="meta-text-color" bindtap="bindComment">马上抢沙发</text>
    </view>
    <view qq:for="{{comments}}" qq:key="id" qq:for-index="index" qq:for-item="items" class="comments-item">
      <view class="author" bindtap="bindReplyComment" id="{{detail.id}}" data-parent="{{items.id}}" data-reply="{{items.author.name}}">
        <image mode="aspectFit" src="{{items.author.avatar}}"></image>
      </view>
      <view class="content">
        <view class="comment-author">
          <view class="author-meta" bindtap="bindReplyComment" id="{{detail.id}}" data-parent="{{items.id}}" data-reply="{{items.author.name}}">{{items.author.name}}</view>
          <view class="author-meta">
            <text class="{{items.islike ? 'cuIcon-appreciatefill' : 'cuIcon-appreciate'}}"> {{items.likes ? items.likes : 0}}</text>
            <button qq:if="{{!user}}" class="thumbs-btn" open-type="getUserInfo" bindgetuserinfo="getProfile"></button>
            <button qq:else class="thumbs-btn" id="{{items.id}}" data-index="{{index}}" bindtap="bindLikeComment"></button>
          </view>
        </view>
        <view class="comment-text">
          {{items.content}}
          <block qq:if="{{items.reply.length > 0}}">
          <view class="comment-reply">
            <view qq:for="{{items.reply}}" qq:key="id" qq:for-index="id" qq:for-item="reply" class="reply-box" bindtap="bindReplyComment" id="{{detail.id}}" data-parent="{{items.id}}" data-reply="{{reply.author.name}}">
              <view class="reply-author">{{reply.author.name}}</view>
              <view class="reply-content">{{reply.content}}</view>
            </view>
          </view>
          </block>
        </view>
      </view>
    </view>
  </view>
</view>
<view capture-catch:touchmove class="textareacontent" qq:if="{{showTextarea}}">
  <form catchsubmit="addComment" report-submit="true">
    <view class="textheaders">
      <view bindtap="bindOutComment" class="cancel">取消</view>
      <button qq:if="{{user}}" class="{{iscanpublish?'publish':'nopublish'}}" form-type="submit">发布</button>
      <button qq:else open-type="getUserInfo" bindgetuserinfo="getProfile" class="{{iscanpublish?'publish':'nopublish'}}">登陆</button>
    </view>
    <view class="textareaBox" qq:if="{{showTextarea}}">
      <view class="textareaInput" qq:if="{{!isFocus}}">{{content}}</view>
      <textarea autoFocus="true" name="content" bindinput="bindCountText" bindblur="onReplyBlur" bindfocus="onRepleyFocus" class="textareaInput {{isFocus?'':'hide'}}" fixed="true" focus="{{isFocus}}" maxlength="140" placeholder="{{placeholder}}" showConfirmBar="{{false}}" value="{{content}}"></textarea>
      <view class="textCount">{{textCount}}/140</view>
    </view>
  </form>
</view>
<view bindtap="bindOutComment" class="pagemake" qq:if="{{showTextarea}}"></view>