library(rvest)
library(stringi)

# get list of all the stories on 2013-06-28
index <- read_html("http://j.people.com.cn/94943/94944/review/20130628.html")
urls <- index %>% 
  html_nodes(xpath="//div[@class='new_list']//a/@href") %>% 
  stri_replace_first_fixed(' href="', '') %>%
  stri_replace_first_fixed('"', '')

# download all the stories and extract body
data <- data.frame()
for (url in urls) {
  url <- paste0("http://j.people.com.cn", url)
  cat("Donwload", url, "\n")
  page <- read_html(url)
  
  body <- page %>% 
    html_node(xpath="//div[@id='p_content']") %>%
    html_text() %>% 
    stri_trim_both()
  
  head <- page %>% 
    html_node(xpath="//h1[@id='p_title']") %>%
    html_text() %>% 
    stri_trim_both()
  
  cat(head, "\n")
  data <- rbind(data, data.frame(url = url, head = head, body = body))
  Sys.sleep(3)
}
