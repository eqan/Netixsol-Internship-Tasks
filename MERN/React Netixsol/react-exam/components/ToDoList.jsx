import React from 'react'
import { useReducer, useState, useRef } from "react";
import styles from '../styles/ToDoList.module.css';

/*
  Use useReducer to manage the state.

  Create a child component as todo Item.

  User can create, edit, delete the todo’s

  each todo item will have a check box.
  by clicking on checkbox it will add a line through the task. denoting as task is completed.
*/

let initialTodos = [];

function reducer(state, action)
{
  var currentNumberOfTasks = Object.keys(state).length;

  switch (action.type)
  {
    case "Create":
      return state.concat({id: currentNumberOfTasks,task: action.task, complete: false});
    case  "Edit":
      return state.map((todo) => {
        if (todo.id === action.id) {
          return { ...todo, task: action.task};
        } 
        else {
          return todo;
        }
      });
    case "Delete":
      return state.filter((task) => task.id !== action.id);
    case "Toggle":
      return state.map((todo) => {
        if (todo.id === action.id) {
          return { ...todo, complete: !todo.complete };
        } 
        else {
          return todo;
        }
      });
      default:
        throw new Error("Option invalid");
  }
}

export default function ToDoList() {
  const [task, setTask] = useState("")
  const [todos, dispatchTodos] = useReducer(reducer, initialTodos);
  const inputElement = useRef(null);

  const onChange = (event) => {
    setTask(event.target.value);
  }

  const handleAdd = (task) => {
    dispatchTodos({ type: "Create", task: task});
    focusInput("");
  };

  const handleToggle = (id) => {
    dispatchTodos({ type: "Toggle", id: id });
  };

  const handleEdit = (todo) => {
    dispatchTodos({ type: "Edit", task: todo.task, id: todo.id });
  };

  const handleDelete = (id) => {
    dispatchTodos({ type: "Delete", id: id });
  };

  const focusInput = (task) => {
    inputElement.current.focus();
    inputElement.current.value = task;
    setTask(task);
  };

  return (
    <>
      <div>
        <input ref={inputElement} onChange={onChange} />
        <button onClick={() => {handleAdd(task)}}>Add Task</button>
      </div>      
      {todos.length > 0 ? todos.map((task) => {
          return (
              <div
                  style={{ backgroundColor: task.complete ? "lightgreen" : "lightyellow" }} className={styles.div}
              >
                <div className={styles.content}>
                  <input style={{marginRight: "10px"}} type="checkbox" defaultChecked={task.complete} onClick={() => {handleToggle(task.id)}}/>
                  <h5 onClick={(e) => {{focusInput(task.task)}; {handleDelete(task.id);}}}>{task.task}</h5>
                </div>
                  <div>
                    <div onClick={() => handleDelete(task.id)}>❌</div>
                  </div>
              </div>
          );
      }) : null}
    </>
  )
}