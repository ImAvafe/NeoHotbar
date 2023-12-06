"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[497],{3905:(e,t,o)=>{o.d(t,{Zo:()=>p,kt:()=>b});var n=o(67294);function r(e,t,o){return t in e?Object.defineProperty(e,t,{value:o,enumerable:!0,configurable:!0,writable:!0}):e[t]=o,e}function a(e,t){var o=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),o.push.apply(o,n)}return o}function i(e){for(var t=1;t<arguments.length;t++){var o=null!=arguments[t]?arguments[t]:{};t%2?a(Object(o),!0).forEach((function(t){r(e,t,o[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(o)):a(Object(o)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(o,t))}))}return e}function l(e,t){if(null==e)return{};var o,n,r=function(e,t){if(null==e)return{};var o,n,r={},a=Object.keys(e);for(n=0;n<a.length;n++)o=a[n],t.indexOf(o)>=0||(r[o]=e[o]);return r}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(n=0;n<a.length;n++)o=a[n],t.indexOf(o)>=0||Object.prototype.propertyIsEnumerable.call(e,o)&&(r[o]=e[o])}return r}var u=n.createContext({}),s=function(e){var t=n.useContext(u),o=t;return e&&(o="function"==typeof e?e(t):i(i({},t),e)),o},p=function(e){var t=s(e.components);return n.createElement(u.Provider,{value:t},e.children)},c="mdxType",m={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},d=n.forwardRef((function(e,t){var o=e.components,r=e.mdxType,a=e.originalType,u=e.parentName,p=l(e,["components","mdxType","originalType","parentName"]),c=s(o),d=r,b=c["".concat(u,".").concat(d)]||c[d]||m[d]||a;return o?n.createElement(b,i(i({ref:t},p),{},{components:o})):n.createElement(b,i({ref:t},p))}));function b(e,t){var o=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var a=o.length,i=new Array(a);i[0]=d;var l={};for(var u in t)hasOwnProperty.call(t,u)&&(l[u]=t[u]);l.originalType=e,l[c]="string"==typeof e?e:r,i[1]=l;for(var s=2;s<a;s++)i[s]=o[s];return n.createElement.apply(null,i)}return n.createElement.apply(null,o)}d.displayName="MDXCreateElement"},17325:(e,t,o)=>{o.r(t),o.d(t,{assets:()=>u,contentTitle:()=>i,default:()=>m,frontMatter:()=>a,metadata:()=>l,toc:()=>s});var n=o(87462),r=(o(67294),o(3905));const a={sidebar_position:2},i="Customization",l={unversionedId:"customization",id:"customization",title:"Customization",description:"Custom buttons",source:"@site/docs/customization.md",sourceDirName:".",slug:"/customization",permalink:"/NeoHotbar/docs/customization",draft:!1,editUrl:"https://github.com/Cyphical/NeoHotbar/edit/master/docs/customization.md",tags:[],version:"current",sidebarPosition:2,frontMatter:{sidebar_position:2},sidebar:"defaultSidebar",previous:{title:"Getting Started",permalink:"/NeoHotbar/docs/intro"}},u={},s=[{value:"Custom buttons",id:"custom-buttons",level:2},{value:"Custom UI",id:"custom-ui",level:2},{value:"Properties",id:"properties",level:2}],p={toc:s},c="wrapper";function m(e){let{components:t,...o}=e;return(0,r.kt)(c,(0,n.Z)({},p,o,{components:t,mdxType:"MDXLayout"}),(0,r.kt)("h1",{id:"customization"},"Customization"),(0,r.kt)("h2",{id:"custom-buttons"},"Custom buttons"),(0,r.kt)("p",null,"You can add your own custom buttons to NeoHotbar, like to open a backpack for example!"),(0,r.kt)("ol",null,(0,r.kt)("li",{parentName:"ol"},(0,r.kt)("p",{parentName:"li"},"First, find an image to use for the button's icon.")),(0,r.kt)("li",{parentName:"ol"},(0,r.kt)("p",{parentName:"li"},"Next, let's add the button to NeoHotbar. We'll use the image's asset ID and a callback function to tell NeoHotbar what to do when it's clicked."),(0,r.kt)("pre",{parentName:"li"},(0,r.kt)("code",{parentName:"pre"},"local NeoHotbar = require(path.to.NeoHotbar)\n\nNeoHotbar:AddCustomButton(\"rbxassetid://0\", function()\n    print('Button was clicked!')\nend)\n"))),(0,r.kt)("li",{parentName:"ol"},(0,r.kt)("p",{parentName:"li"},"You're done! You can hook this button up to whatever you want in your game."))),(0,r.kt)("h2",{id:"custom-ui"},"Custom UI"),(0,r.kt)("p",null,"NeoHotbar's UI is fully overridable, so you can customize it however you like! You can also plug into dynamic attributes like ",(0,r.kt)("inlineCode",{parentName:"p"},"Equipped")," to have your UI react to changes."),(0,r.kt)("ol",null,(0,r.kt)("li",{parentName:"ol"},"Copy over the default UI to use as a template. The folder can be found in ",(0,r.kt)("inlineCode",{parentName:"li"},"NeoHotbar/DefaultInstances"),"."),(0,r.kt)("li",{parentName:"ol"},"Modify all you like, you have full control!"),(0,r.kt)("li",{parentName:"ol"},"Call ",(0,r.kt)("a",{parentName:"li",href:"/api/NeoHotbar#OverrideGui"},":OverrideGui()")," on NeoHotbar, passing your folder as an argument.")),(0,r.kt)("h2",{id:"properties"},"Properties"),(0,r.kt)("p",null,"You might want to change simpler things, like temporarily hiding the hotbar or locking tool reordering. You can set those properties with the functions listed here:"),(0,r.kt)("ul",null,(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("a",{parentName:"li",href:"/api/NeoHotbar#SetEnabled"},"SetEnabled")),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("a",{parentName:"li",href:"/api/NeoHotbar#SetManagementEnabled"},"SetManagementEnabled")),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("a",{parentName:"li",href:"/api/NeoHotbar#SetToolTipsEnabled"},"SetToolTipsEnabled")),(0,r.kt)("li",{parentName:"ul"},(0,r.kt)("a",{parentName:"li",href:"/api/NeoHotbar#SetContextMenuEnabled"},"SetContextMenuEnabled"))))}m.isMDXComponent=!0}}]);