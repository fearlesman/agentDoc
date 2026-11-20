import React from "react";
import { createRoot } from "react-dom/client";
import "./style.css";

function App() {
  return <main><h1>文档智能同行评审 Agent</h1><p>项目基座已就绪，等待四个模块接入。</p></main>;
}

createRoot(document.getElementById("root")!).render(<React.StrictMode><App /></React.StrictMode>);
