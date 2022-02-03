<!doctype html>
<html lang="en">
  <head>
    <title>Task</title>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <script type="text/javascript" src="https://unpkg.com/vue@2.3.4"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue-resource@1.3.4"></script>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <style type="text/css">
      .del {
          text-decoration: line-through;
      }
      .card{
        border-radius: 0 !important;
        border: none;
      }
      .card-body{
        padding: 0 !important;
      }
      .task-title{
        width: 100%;
        background: purple;
        color: #FFF
        ;
        font-size: 30px;
        font-weight: bold;
        padding: 20px 10px;
        text-align: center;
        border-top-left-radius: 5px;
        border-top-right-radius: 5px;
      }
      .custom-input{
        border-radius: 0 !important;
        padding: 10px 10px !important;
        border-bottom: none;
      }
      .custom-input:focus, .custom-input:active{
        box-shadow: none !important;
      }
      .custom-button{
        border-radius: 0 !important;
        cursor: pointer;
      }
      .custom-button:focus, .custom-button:active{
        box-shadow: none !important;
      }
      .list-group li{
        cursor: pointer;
        border-radius: 0 !important;
      }
      .checked{
        background: #5e6669;
        color: #95a5a6;
      }
      .error{
        border: 2px solid #e74c3c !important;
      }
      .not-checked{
        background: #2227c7;
        color: #FFF;
        font-weight: bold;
      }
    </style>
  </head>
  <body>
    <div class="container" id="root">
        <div class="row">
            <div class="col-6 offset-3">
                <br><br>
                <div class="card">
                  <div class="task-title">
                    Daily Task Lists
                  </div>
                  <div class="card-body">
                      <form v-on:submit.prevent>
                        <div class="input-group">
                          <input type="text" v-model="task.title" v-on:keyup="checkForEnter($event)" class="form-control custom-input" :class="{ 'error': showError }" placeholder="Add your task">
                          <span class="input-group-btn">
                            <button class="btn custom-button" :class="{'btn-success' : !enableEdit, 'btn-warning' : enableEdit}" type="button"  v-on:click="addTask"><span :class="{'fa fa-plus' : !enableEdit, 'fa fa-edit' : enableEdit}"></span></button>
                          </span>
                        </div>
                      </form>
                      <ul class="list-group">
                        <li class="list-group-item" :class="{ 'checked': task.completed, 'not-checked': !task.completed }" v-for="(task, taskIndex) in tasks" v-on:click="toggleTask(task, taskIndex)">
                            <i :class="{'fa fa-circle': !task.completed, 'fa fa-check-circle text-success': task.completed }">&nbsp;</i>
                            <span :class="{ 'del': task.completed }">@{ task.title }</span>
                            <div class="btn-group float-right" role="group" aria-label="Basic example">
                              <button type="button" class="btn btn-success btn-sm custom-button" v-on:click.prevent.stop v-on:click="editTask(task, taskIndex)"><span class="fa fa-edit"></span></button>
                              <button type="button" class="btn btn-danger btn-sm custom-button" v-on:click.prevent.stop v-on:click="deleteTask(task, taskIndex)"><span class="fa fa-trash"></span></button>
                            </div>
                        </li>
                      </ul>
                  </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>
    <script type="text/javascript">
      var Vue = new Vue({
        el: '#root',
        delimiters: ['@{', '}'],
        data: {
          showError: false,
          enableEdit: false,
          task: {id: '', title: '', completed: false},
          tasks: []
        },
        mounted () {
          this.$http.get('task').then(response => {
            this.tasks = response.body.data;
          });
        },
        methods: {
          addTask(){
            if (this.task.title == ''){
              this.showError = true;
            }else{
              this.showError = false;
              if(this.enableEdit){
                this.$http.put('task/'+this.task.id, this.task).then(response => {
                  if(response.status == 200){
                    this.tasks[this.task.taskIndex] = this.task;
                  }
                });
                this.task = {id: '', title: '', completed: false};
                this.enableEdit = false;
              }else{
                this.$http.post('task', {title: this.task.title}).then(response => {
                  if(response.status == 201){
                    this.tasks.push({id: response.body.task_id, title: this.task.title, completed: false});
                    this.task = {id: '', title: '', completed: false};
                  }
                });
              }
            }
          },
          checkForEnter(event){
            if (event.key == "Enter") {
              this.addTask();
            }
          },
          toggleTask(task, taskIndex){
            var completedToggle;
            if (task.completed == true) {
              completedToggle = false;
            }else{
              completedToggle = true;
            }
            this.$http.put('task/'+task.id, {id: task.id, title: task.title, completed: completedToggle}).then(response => {
              if(response.status == 200){
                this.task[taskIndex].completed = completedToggle;
              }
            });
          },
          editTask(task, taskIndex){
            this.enableEdit = true;
            this.task = task;
            this.task.taskIndex = taskIndex;
          },
          deleteTask(task, taskIndex){
            if(confirm("Are you sure ?")){
              this.$http.delete('task/'+task.id).then(response => {
                if(response.status == 200){
                  this.tasks.splice(taskIndex, 1);
                  this.task = {id: '', title: '', completed: false};
                }
              });
            }
          }
        }
      });
    </script>
  </body>
</html>