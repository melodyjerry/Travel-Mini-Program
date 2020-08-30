<!--**
 * author: Di (微信小程序开发工程师)
 * organization: WeAppDev(微信小程序开发论坛)(http://weappdev.com)
 *               垂直微信小程序开发交流社区
 * 
 * github地址: https://github.com/icindy/wxParse
 * 
 * for: 微信小程序富文本解析
 * detail : http://weappdev.com/t/wxparse-alpha0-1-html-markdown/184
 * A 标签链接增强版 + 音频播放 - By 艾码汇(https://www.imahui.com)
 */-->

<!--基础元素-->
<template name="wxParseVideo">
  <!--增加video标签支持，并循环添加-->
  <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
    <video object-fit="contain" class="{{item.classStr}} wxParse-{{item.tag}}-video" src="{{item.attr.src}}" poster='{{item.attr.poster}}'></video>
  </view>
</template>
<template name="wxParseAudio">
  <!--增加audio标签支持，并循环添加-->
  <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
    <!--audio poster="{{item.attr.poster}}" name="{{item.attr.name}}" author="{{item.attr.author}}" src="{{item.attr.src}}" id="Audio" controls loop></audio-->
    <view class="wxParseAudioView" data-src="{{item.attr.src}}" bindtap="wxParseAudioPlay">
      <view class="WxEmojiView wxParse-inline AudioPlayTips">
        <text>点击播放:</text>
      </view>
      <view class="AudioTitleText">
        <text>{{item.attr.title ? item.attr.title : '未知作品辑'}}{{item.attr.author ? ' - ' + item.attr.author : ''}}</text>
      </view>
    </view>
  </view>
</template>
<template name="wxParseImg">
  <image class="{{item.classStr}} wxParse-{{item.tag}}" data-from="{{item.from}}" data-src="{{item.attr.src}}" data-idx="{{item.imgIndex}}" src="{{item.attr.src}}" mode="aspectFit" bindload="wxParseImgLoad" bindtap="wxParseImgTap" style="{{item.width?'width:' + item.width + 'px;':''}}{{item.height?'height:' + item.height + 'px;':''}}"
  />
</template>
<!--33行加入text组件，用于复制文字-->
<template name="WxEmojiView">
  <view class="WxEmojiView wxParse-inline" style="{{item.styleStr}}">
    <block qq:for="{{item.textArray}}" qq:key="item">
      <block class="{{item.text == '\\n' ? 'wxParse-hide':''}}" qq:if="{{item.node == 'text'}}"><text selectable="{{true}}">{{item.text}}</text></block>
      <block qq:elif="{{item.node == 'element'}}">
        <image class="wxEmoji" src="{{item.baseSrc}}{{item.text}}" />
      </block>
    </block>
  </view>
</template>

<template name="WxParseBr">
  <text>\n</text>
</template>
<!--入口模版-->

<template name="wxParse">
  <block qq:for="{{wxParseData}}" qq:key="item">
    <template is="wxParse0" data="{{item}}" />
  </block>
</template>


<!--循环模版-->
<template name="wxParse0">
  <!--<template is="wxParse1" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse1" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse1" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse1" data="{{item}}" />
        </block>
      </view>
    </block>
    <block qq:elif="{{item.tag == 'table'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse1" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse1" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse1" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>



<!--循环模版-->
<template name="wxParse1">
  <!--<template is="wxParse2" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse2" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse2" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse2" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse2" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse2" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>


<!--循环模版-->
<template name="wxParse2">
  <!--<template is="wxParse3" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse3" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse3" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse3" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse3" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse3" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse3">
  <!--<template is="wxParse4" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse4" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse4" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse4" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse4" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse4" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse4">
  <!--<template is="wxParse5" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse5" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse5" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse5" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse5" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse5" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse5">
  <!--<template is="wxParse6" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse6" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse6" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse6" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse6" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse6" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse6">
  <!--<template is="wxParse7" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse7" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse7" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse7" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse7" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse7" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>
<!--循环模版-->
<template name="wxParse7">
  <!--<template is="wxParse8" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse8" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse8" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse8" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse8" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse8" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse8">
  <!--<template is="wxParse9" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse9" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse9" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse9" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse9" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse9" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse9">
  <!--<template is="wxParse10" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse10" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse10" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse10" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse10" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse10" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse10">
  <!--<template is="wxParse11" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse11" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse11" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse11" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse11" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse11" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse11">
  <!--<template is="wxParse12" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse12" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse12" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse12" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse12" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse12" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse12">
  <!--<template is="wxParse13" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse13" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse13" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse13" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse13" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse13" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse13">
  <!--<template is="wxParse14" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse14" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse14" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse14" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse14" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse14" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse14">
  <!--<template is="wxParse15" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse15" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse15" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse15" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse15" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse15" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse15">
  <!--<template is="wxParse16" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse16" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse16" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse16" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse16" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse16" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse16">
  <!--<template is="wxParse17" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse17" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse17" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse17" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse17" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse17" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse17">
  <!--<template is="wxParse18" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse18" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse18" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse18" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse18" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse18" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse18">
  <!--<template is="wxParse19" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse19" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse19" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse19" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse19" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse19" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse19">
  <!--<template is="wxParse20" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse20" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse20" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse20" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse20" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse20" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse20">
  <!--<template is="wxParse21" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse21" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse21" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse21" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse21" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse21" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse21">
  <!--<template is="wxParse22" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse22" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse22" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse22" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse22" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse22" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>

<!--循环模版-->
<template name="wxParse22">
  <!--<template is="wxParse22" data="{{item}}" />-->
  <!--判断是否是标签节点-->
  <block qq:if="{{item.node == 'element'}}">
    <block qq:if="{{item.tag == 'button'}}">
      <button type="default" size="mini">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse23" data="{{item}}" />
        </block>
      </button>
    </block>
    <!--li类型-->
    <block qq:elif="{{item.tag == 'li'}}">
      <view class="{{item.classStr}} wxParse-li" style="{{item.styleStr}}">
        <view class="{{item.classStr}} wxParse-li-inner">
          <view class="{{item.classStr}} wxParse-li-text">
            <view class="{{item.classStr}} wxParse-li-circle"></view>
          </view>
          <view class="{{item.classStr}} wxParse-li-text">
            <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
              <template is="wxParse23" data="{{item}}" />
            </block>
          </view>
        </view>
      </view>
    </block>

    <!--video类型-->
    <block qq:elif="{{item.tag == 'video'}}">
      <template is="wxParseVideo" data="{{item}}" />
    </block>

    <!--audio类型-->
    <block qq:elif="{{item.tag == 'audio'}}">
      <template is="wxParseAudio" data="{{item}}" />
    </block>

    <!--img类型-->
    <block qq:elif="{{item.tag == 'img'}}">
      <template is="wxParseImg" data="{{item}}" />
    </block>

    <!--a类型-->
    <block qq:elif="{{item.tag == 'a'}}">
      <view bindtap="wxParseTagATap" class="wxParse-inline {{item.classStr}} wxParse-{{item.tag}}" data-appid="{{item.attr.appid}}" data-type="{{item.attr.type}}" data-path="{{item.attr.path}}" data-src="{{item.attr.href}}" style="{{item.styleStr}}">
        <view class="WxEmojiView wxParse-inline" qq:if="{{item.attr.type == 'miniprogram'}}">
          <text class="wxParseIconFonts vicon-miniprogram"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:elif="{{item.attr.type == 'document'}}">
          <text class="wxParseIconFonts vicon-document"></text>
        </view>
        <view class="WxEmojiView wxParse-inline" qq:else>
          <text class="wxParseIconFonts vicon-link"></text>
        </view>
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse23" data="{{item}}" />
        </block>
      </view>
    </block>

    <block qq:elif="{{item.tag == 'br'}}">
      <template is="WxParseBr"></template>
    </block>
    <!--其他块级标签-->
    <block qq:elif="{{item.tagType == 'block'}}">
      <view class="{{item.classStr}} wxParse-{{item.tag}}" style="{{item.styleStr}}">
        <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
          <template is="wxParse23" data="{{item}}" />
        </block>
      </view>
    </block>

    <!--内联标签-->
    <view qq:else class="{{item.classStr}} wxParse-{{item.tag}} wxParse-{{item.tagType}}" style="{{item.styleStr}}">
      <block qq:for="{{item.nodes}}" qq:for-item="item" qq:key="item">
        <template is="wxParse23" data="{{item}}" />
      </block>
    </view>

  </block>

  <!--判断是否是文本节点-->
  <block qq:elif="{{item.node == 'text'}}">
    <!--如果是，直接进行-->
    <template is="WxEmojiView" data="{{item}}" />
  </block>

</template>