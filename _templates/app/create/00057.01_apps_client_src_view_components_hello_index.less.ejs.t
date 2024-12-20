---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/view/components/hello/index.less`) %>
unless_exists: true
---
.button {
  margin-right: 5px;
  border-radius: 5px;
  height: 30px;
  width: 100px;
}

.react {
  margin: -50px 0 0 -130px;
  background-image: radial-gradient(
    circle at 130px 50px,
    #00dfde 0,
    #00dfde 21.6667px,
    transparent 30px
  );
  width: 260px;
  height: 100px;
  position: absolute;
  border: 10px #00dfde solid;
  border-radius: 100%;
  animation: reacting ease-in-out 0.7s infinite, blink 2s infinite alternate ease-in;
}

.react::before,
.react::after {
  content: '';
  width: 260px;
  height: 100px;
  position: absolute;
  border: 10px #00dfde solid;
  border-radius: 100%;
  top: -10px;
  left: -10px;
}

.react::before {
  transform: rotate(60deg);
  animation: reacting ease-in-out 0.7s 0.2s infinite;
}

.react::after {
  animation: reacting ease-in-out 0.7s 0.4s infinite;
  transform: rotate(-60deg);
}

@-moz-keyframes reacting {
  20% {
    border-left: 0;
  }
  40% {
    border-top: 0;
  }
  60% {
    border-right: 0;
  }
  80% {
    border-bottom: 0;
    opacity: 0.8;
  }
}

@-webkit-keyframes reacting {
  20% {
    border-left: 0;
  }
  40% {
    border-top: 0;
  }
  60% {
    border-right: 0;
  }
  80% {
    border-bottom: 0;
    opacity: 0.8;
  }
}

@-o-keyframes reacting {
  20% {
    border-left: 0;
  }
  40% {
    border-top: 0;
  }
  60% {
    border-right: 0;
  }
  80% {
    border-bottom: 0;
    opacity: 0.8;
  }
}

@keyframes reacting {
  20% {
    border-left: 0;
  }
  40% {
    border-top: 0;
  }
  60% {
    border-right: 0;
  }
  80% {
    border-bottom: 0;
    opacity: 0.8;
  }
}

.author {
  font-family: monospace;
  color: #fff;
  font-size: 16px;
  text-transform: uppercase;
  margin-top: 80vh;
}

@-moz-keyframes blink {
  to {
    filter: hue-rotate(360deg) brightness(2) saturate(2) blur(1px);
  }
}

@-webkit-keyframes blink {
  to {
    filter: hue-rotate(360deg) brightness(2) saturate(2) blur(1px);
  }
}

@-o-keyframes blink {
  to {
    filter: hue-rotate(360deg) brightness(2) saturate(2) blur(1px);
  }
}

@keyframes blink {
  to {
    filter: hue-rotate(360deg) brightness(2) saturate(2) blur(1px);
  }
}
